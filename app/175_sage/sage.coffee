if Meteor.isClient
  # Sage exports
  class @SageExporter
    constructor: ->
      appLog.info 'Creating SAGE export'
      @content = []
    # Drapeau d’en-tête (#FLG)
    headFlag: (version) ->
      @write "#FLG #{s.lpad version, 3, '0'}"
      @
    # Drapeau de version (#VER)
    versionFlag: (version) ->
      @write "#VER #{version}"
      @
    # Document ("#CHEN")
    document: (invoiceDate, fullName)->
      options =
        # Domain: VENTE
        domain: { fct: 'write', val: 1}
        # VENTE, FACTURE
        type: { fct: 'write', val: 7}
        # VENTE: 1: Basic
        origin: { fct: 'write', val: 1}
        # Souche: 1-50
        stub: { fct: 'write', val: 6}
        # N° de pièce (max 9 chars)
        pieceNum: { fct: 'write9', val: 'NUMFAC'}
        # Date facture
        date: { fct: 'writeDate', val: invoiceDate}
        # Référence (max 17 chars) NOM RESERVATAIRE
        reference: { fct: 'write17', val: fullName}
        # Livraison (date)
        deliveryDate: { fct: 'writeDate', val: null}
        # Livraison réalisée (date)
        doneDeliveryDate: { fct: 'writeDate', val: null}
        # Date d'expédition (réservé à l'export)
        shipmentDate: { fct: 'writeDate', val: null}
        # Tiers (max 17 chars)
        tiers: { fct: 'write17', val: 'CONGRES'}
        # Dépôt de stockage (max 35 chars)
        storageDeposit: { fct: 'write35', val: 'APFORM'}
        # Dépôt de livraison (max 35 chars)
        deliveryDeposit: { fct: 'write35', val: 'CONGRE - SOIREES'}
        # Périodicité de 1 à 10
        periodicity: { fct: 'write', val: 1}
        # Devise de 0 à 32
        currency: { fct: 'write', val: 0}
        # Cours (de la devise)
        currencyPrice: { fct: 'writePrice', val: 0}
        # Payeur/encaisseur (max 17 chars)
        collector: { fct: 'write17', val: 'CONGRES'}
        # Expédition de 1 à 50
        shipmentNumber: { fct: 'write', val: 1}
        # Condition de livraison de 1 à 50
        deliveryCondition: { fct: 'write', val: 1}
        # Langue
        deliveryLanguage: { fct: 'write', val: 0}
        # Nom représentant (max 35 chars)
        agentName: { fct: 'write35', val: ''}
        # Prénom représentant (max 35 chars)
        agentForname: { fct: 'write35', val: ''}
        # En-tête 1 (max 25 chars)
        agentHeader1: { fct: 'write25', val: ''}
        # En-tête 2 (max 25 chars)
        agentHeader2: { fct: 'write25', val: ''}
        # En-tête 3 (max 25 chars)
        agentHeader3: { fct: 'write25', val: ''}
        # En-tête 4 (max 25 chars)
        agentHeader4: { fct: 'write25', val: ''}
        # Affaire
        deal: { fct: 'write', val: '99DIV'}
        # Catégorie tarifaire de 1 à 32
        rateCategory: { fct: 'write', val: 1}
        # Régime 2 chars numériques
        regime: { fct: 'write', val: '21'}
        # Transation 2 chars numériques
        transaction: { fct: 'write', val: '11'}
        # Colisage (quantité)
        packing: { fct: 'write', val: 1}
        # Unité de colisage de 1 à 30
        packingUnit: { fct: 'write', val: 1}
        # Nbre d'exemplaires de 0 à 99
        copies: { fct: 'write', val: 1}
        # 0: Une facture ou BL, 1: plusieurs
        monoInvoice: { fct: 'write', val: 0}
        # Taux d'escompte
        discountRate: { fct: 'writeDouble', val: 0}
        # Ecart valorisation
        valuationGap: { fct: 'writeDouble', val: 0}
        # Catégorie comptable de 1 à 50
        accountingCategory: { fct: 'write', val: 0}
        # Frais: 0 non ventilé, 1 ventilé (achat)
        expenseFlag: { fct: 'write', val: 0}
        # Statut: 0, 1, 2
        stockStatus: { fct: 'write', val: 2}
        # Compte général
        generalAccount: { fct: 'write', val: '41100000'}
        # Heure
        hour: { fct: 'writeHour', val: invoiceDate}
        # Caisse (max 35 chars)
        cashier: { fct: 'write35', val: ''}
        # Nom du caissier (max 35 chars)
        cashierName: { fct: 'write35', val: ''}
        # Prénom du caissier (max 35 chars)
        cashierForname: { fct: 'write35', val: ''}
        # Clôturé: 0 non, 1 oui
        closed: { fct: 'write', val: 0}
        # N° de cmde du site marchand (max 17 chars)
        eShopNumber: { fct: 'write17', val: ''}
        # Ventilation IFRS
        accountSpread: { fct: 'write', val: ''}
        # Type de calcul de frais
        deliveryExpenseCalculationType: { fct: 'write', val: 0}
        # Valeur de frais d'expédition
        deliveryExpenseValue: { fct: 'writeNumeric', val: 0}
        # Type valeur frais expédition: 0 HT, 1 TTC
        deliveryExpenseValueType: { fct: 'write', val: 0}
        # Type de calcul de franco de port
        carriageCalculationType: { fct: 'write', val: 0}
        # Valeur de franco de port
        carriageValue: { fct: 'writeNumeric', val: 0}
        # Type de franco de port: 0 HT, 1 TTC
        carriageType: { fct: 'write', val: 0}
        # Taux de taxe 1
        taxRate1: { fct: 'writeDouble', val: 0}
        # Type de taux de taxe 1
        taxRateType1: { fct: 'write', val: 0}
        # Type de taxe 1
        taxType1: { fct: 'write', val: 0}
        # Taux de taxe 2
        taxRate2: { fct: 'writeDouble', val: 0}
        # Type de taux de taxe 2
        taxRateType2: { fct: 'write', val: 0}
        # Type de taxe 2
        taxType2: { fct: 'write', val: 0}
        # Taux de taxe 3
        taxRate3: { fct: 'writeDouble', val: 0}
        # Type de taux de taxe 3
        taxRateType3: { fct: 'write', val: 0}
        # Type de taxe 3
        taxType3: { fct: 'write', val: 0}
        # Motif (max 35 chars)
        reason: { fct: 'write35', val: ''}
        # Centrale d'achat (max 17 chars)
        centralPurchasing: { fct: 'write17', val: ''}
        # Contact (max 35 chars)
        centralContact: { fct: 'write35', val: ''}
        # Statut rectifié
        rectifiedStatus: { fct: 'write', val: 0}
        # Type transaction
        transactionType: { fct: 'write', val: 0}
        # Validé: 0 non validé, 1 validé
        validatedSale: { fct: 'write', val: 0}
        # N° FA origine
        faOriginNumber: { fct: 'write9', val: ''}
        # Code taxe 1
        taxCode1: { fct: 'write9', val: ''}
        # Code taxe 2
        taxCode2: { fct: 'write9', val: ''}
        # Code taxe 3
        taxCode3: { fct: 'write9', val: ''}
      @write "#CHEN"
        .writeDict options
    # Informations libres (#CIVA)
    freeInformation: (fullName) ->
      options =
        # NOM PARTICIPANT OU RESERVATAIRE
        fullName: {fct: 'write35', val: fullName}
        # ADRESSE 1
        address1: {fct: 'write35', val: ''}
        # ADRESSE 2
        address2: {fct: 'write35', val: ''}
        # ADRESSE 3
        address3: {fct: 'write35', val: ''}
        # CP + VILLE
        postalCodeCity: {fct: 'write35', val: ''}
        # Blank line
        dummy: {fct: 'write', val: ''}
      @write '#CIVA'
        .writeDict options
    # Lignes de document (#CHLI)
    documentLines: (fullName) ->
      # NOM RESERVATAIRE
      options =
        # Référence ligne (max 17 chars): NOM PARTICIPANT OU RESERVATAIRE
        lineReference: {fct: 'write17', val: fullName}
        # Référence article (max 18 chars): 99ASV
        articleReference: {fct: 'write18', val: '99ASV'}
        # Désignation (max 19 chars)
        designation:{fct:'write69',val:'PARTICIPATION SOIREE ASV-CONGRES AFVAC'}
        # Texte complémentaire (max 1980 chars)
        additionalText: {fct: 'write1980', val: ''}
        # Enuméré de gamme 1 (max 21 chars)
        listedRange1: {fct: 'write21', val: ''}
        # Enuméré de gamme 2 (max 21 chars)
        listedRange2: {fct: 'write21', val: ''}
        # N° de série & Lot (max 30 chars)
        serialNbBatch: {fct: 'write30', val: ''}
        # Complément série/lot
        
      @write '#CHLI'
        .writeDict options
    # Fin (#FIN)
    end: ->
      @write '#FIN'
      @
    writeDate: (date) ->
      if date is null
        @content.push ''
        return @
      @write moment(date).format 'DDMMYYYY'
    writeHour: (date) ->
      if date is null
        @content.push ''
        return @
      @write moment(date).format 'hh:mm:ss'
    writePrice: (price) -> @write s.numberFormat price, 6, ',', ''
    writeNumeric: (amount) -> @write s.numberFormat amount, 2, ',', ''
    writeDouble: (amount) -> @write s.numberFormat amount, 4, ',', ''
    write9: (data) -> @write data.substr 0, 9
    write17: (data) -> @write data.substr 0, 17
    write18: (data) -> @write data.substr 0, 18
    write19: (data) -> @write data.substr 0, 19
    write21: (data) -> @write data.substr 0, 21
    write25: (data) -> @write data.substr 0, 25
    write30: (data) -> @write data.substr 0, 30
    write35: (data) -> @write data.substr 0, 35
    write1980: (data) -> @write data.substr 0, 1980
    write: (data) ->
      txt = (Diacritics.clean String data).toUpperCase()
      @content.push txt
      @
    writeDict: (dict) ->
      for key, val of dict
        @[val.fct] val.val
      @
    toString: -> @content.join '\n'

  @se = {}
  Meteor.startup ->
    @se = new SageExporter
    invoiceDate = new Date
    se.headFlag 0                   # Get this value from Orion's dictionary
      .versionFlag 18               # Match export in Sage 7.70
      .document invoiceDate, 'Aurélie De Barros'
      .freeInformation 'Aurélie De Barros'
      .documentLines 'Aurélie De Barros'
      .end()
    appLog.warn se.toString()
