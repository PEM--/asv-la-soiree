if Meteor.isClient
  # Sage exports
  class @SageExporter
    constructor: ->
      appLog.info 'Creating SAGE export'
      @content = []
    # Drapeau d’en-tête
    headFlag: (version) ->
      @write "#FLG #{s.lpad version, 3, '0'}"
      @
    # Drapeau de version
    versionFlag: (version) ->
      @write "#VER #{version}"
      @
    # Document
    # Document: Drapeau d'en-tête
    documentHeadFlag: (domain, type, origin, stub) ->
      @write "#CHEN"
        .write domain
        .write type
        .write origin
        .write stub
      @
    # Fin
    end: ->
      @write '#FIN'
      @
    write: (data) ->
      txt = Diacritics.clean String data
      appLog.info 'Sage writing', txt
      @content.push txt
      @
    toString: -> @content.join '\n'

  Meteor.startup ->
    se = new SageExporter
    se.headFlag 0                   # Get this value from Orion's dictionary
      .versionFlag 18               # Match export in Sage 7.70
      .documentHeadFlag 1, 7, 1, 6  # New document

      .end()
    appLog.warn se.toString()

  # NUMFAC
  # 170715
  # NOM RESERVATAIRE
  #
  #
  #
  # CONGRES
  # APFORM
  # CONGRES - SOIREES
  # 1
  # 0
  # 0,000000
  # CONGRES
  # 1
  # 1
  # 0
  #
  #
  #
  #
  #
  #
  # 99DIV
  # 1
  # 21
  # 11
  # 1
  # 1
  # 1
  # 0
  # 0,0000
  # 0,0000
  # 1
  # 0
  # 2
  # 41100000
  # 09:29:05
  #
  #
  #
  # 0
  #
  #
  # 0
  # 0,00
  # 0
  # 0
  # 0,00
  # 0
  # 0,0000
  # 0
  # 0
  # 0,0000
  # 0
  # 0
  # 0,0000
  # 0
  # 0
  #
  #
  #
  # 0
  # 0
  # 0
  #
  #
  #
  #
