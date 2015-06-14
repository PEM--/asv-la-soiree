if Meteor.isClient
  @blobDownload = (content, fileName, mimeType) ->
    a = document.createElement 'a'
    mimeType = mimeType or 'application/octet-stream'
    if navigator.msSaveBlob
      # IE10
      navigator.msSaveBlob new Blob([ content ], type: mimeType), fileName
    else if 'download' of a
      # HTML5 A[download]
      a.href = 'data:' + mimeType + ',' + encodeURIComponent(content)
      a.setAttribute 'download', fileName
      document.body.appendChild a
      setTimeout (->
        a.click()
        document.body.removeChild a
        return
      ), 66
      true
    else
      # IFRAME dataURL download for old Chrome and FF
      f = document.createElement('iframe')
      document.body.appendChild f
      f.src = 'data:' + mimeType + ',' + encodeURIComponent(content)
      setTimeout (->
        document.body.removeChild f
        return
      ), 333
      true
