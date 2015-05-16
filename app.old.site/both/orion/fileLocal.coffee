# # Orion provider config
# ###*
#  * Provider upload function
#  *
#  * Please replace this function with the
#  * provider you prefer.
#  *
#  * If success, call success(publicUrl);
#  * you can pass data and it will be saved in file.meta
#  * Ej: success(publicUrl, {local_path: '/user/path/to/file'})
#  *
#  * If it fails, call failure(error).
#  *
#  * When the progress change, call progress(newProgress)
# ###
# if Meteor.isClient
#   orion.filesystem.providerUpload = (options, success, failure, progress) ->
#     _.each options.fileList, (file) ->
#       Files.insert file, (err, file) ->
#         if err
#           console.log 'error', err
#         else
#           # Recreate upload file pattern
#           fileName = "#{file.collectionName}-#{file._id}-#{file.original.name}"
#           fileUrl = "#{Meteor.absoluteUrl()}uploads/#{fileName}"
#           success fileUrl
#
#    orion.filesystem.providerRemove = (file, success, failure)  ->
#     Files.remove file._id, (err) ->
#       if err
#         console.log 'error', err
#
# base = ''
#
# if Meteor.isServer
#   base = process.env.PWD
#
# Files = new FS.Collection 'files',
#   stores: [
#     new FS.Store.FileSystem 'files', path: "#{base}/public/uploads"
#   ],
#   filter: allow: contentTypes: ['image/*']
#
# Files.deny
#   insert: -> false
#   update: -> false
#   remove: -> false
#   download: -> false
#
# Files.allow
#   insert: -> true
#   update: -> true
#   remove: -> true
#   download: -> true
