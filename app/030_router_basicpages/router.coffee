# Simple pages for Home, EULA, Cookies
@BasicPages = new orion.collection 'basicpages',
  singularName: 'page basique'
  pluralName: 'pages basiques'
  title: 'Pages basiques'
  link: title: 'Pages basiques'
  tabular:
    columns: [
      { data: 'title', title: 'Titre'  }
      { data: 'slug', title: 'Slug'  }
      orion.attributeColumn 'froala', 'body', 'Contenu'
    ]
BasicPages.attachSchema new SimpleSchema
  title: type: String
  slug: type: String
  # Order is used to influence links ordering in the menu or in the footer
  order: type: Number, min: 1, label: 'Ordre'
  # Set link dispaly of the page in the menu and the footer
  display:
    type: Number
    allowedValues: [1, 2, 3]
    label: 'Affichage'
    autoform: options: [
      {value: 1, label: 'Menu et Footer'}
      {value: 2, label: 'Menu uniquement'}
      {value: 3, label: 'Footer uniquement'}
    ]
  body: orion.attribute 'froala', label: 'Contenu'
  createdBy: orion.attribute 'createdBy'
  createdAt: orion.attribute 'createdAt'
BasicPages.helpers
  getCreator: ->
    Meteor.users.findOne @createdBy

# Create 2 default pages for cookie policy and legal mentions
if Meteor.isServer
  try
    # Get first admin available
    users = Meteor.users.find().fetch()
    throw new Meteor.Error 'init', 'No user created' if users.length is 0
    admin = _.find users, (user) -> Roles.userHasRole user._id, 'admin'
    throw new Meteor.Error 'init', 'No admin user' if admin is undefined
    # Check if CGU exists
    if BasicPages.find(slug: 'cgu').count() is 0
      appLog.info 'No CGU found. Creating default ones.'
      BasicPages.insert
        title: 'Mentions légales'
        slug: 'cgu'
        order: 1
        display: 3
        body: '<p class="fr-tag"><strong>Adresse légale de l\'éditeur&nbsp;:</strong>&nbsp;APForm - 10 place Léon Blum - 75011 Paris</p><p class="fr-tag"><strong>Responsable de la base de données&nbsp;:</strong>&nbsp;APForm</p><p class="fr-tag"><strong>Hébergeur</strong><br>OVH - 2 rue Kellermann - 59100 Roubaix - France</p><p class="fr-tag"><strong>Conception/Réalisation</strong><br>Pierre-Eric Marchandet - 85, avenue du docteur Arnold Netter - 75012 Paris</p><p class="fr-tag"><strong>1. Loi Informatique, fichiers et libertés</strong><br>Le site est en cours de déclaration à la CNIL : n° d\'enregistrement CNIL à venir.</p><p class="fr-tag">Conformément aux articles 39 et suivants de la loi n° 78-17 du 6 janvier 1978, relative à l\'Informatique, aux Fichiers et aux Libertés, toute personne peut demander la communication des informations la concernant, et le cas échant demander la rectification, ou la suppression des données à caractère personnel faisant l\'objet d\'un traitements sous la responsabilité d\'APForm. Pour ce faire vous pouvez adresser votre demande directement auprès d\'APForm.</p><p class="fr-tag"><strong>2. Protection de la propriété intellectuelle</strong><br>Ce site est édité par APForm, lequel est titulaire des droits relatifs aux éléments contenus dans le site. On entend par contenu du site web, la structure générale, les textes, les images, animées ou non, et les sons dont le site est composé. Toute représentation ou reproduction intégrale ou partielle faite sans le consentement de l\'association APform est illicite. Cette représentation ou reproduction, par quelque procédé que ce soit, serait constitutif d\'une contrefaçon sanctionnée par la législation en vigueur sur la propriété intellectuelle. L\'ensemble des dispositions du code de la Propriété Intellectuelle sont applicables en l\'espèce, notamment les articles &nbsp;L 342-1 et L342 -2 dudit code.</p><p class="fr-tag"><strong>3. Autorisations de reproduction du contenu du site</strong><br>Conformément aux dispositions du Code de la Propriété Intellectuelle, sont autorisées "les copies ou reproductions strictement réservées à l\'usage privé du copiste et non destiné à une utilisation collective" et "les représentations privées et gratuites effectuées exclusivement dans un cercle de famille".</p><p class="fr-tag">En conséquence, sauf autorisation écrite préalable de l\'association APForm, il est interdit de faire un usage commercial ou autre ou de transmettre un ou plusieurs éléments constituant ce site, mais aussi de modifier, rediffuser, traduire, vendre, exploiter, réutiliser, présenter, l\'un des éléments quelconque constitutifs de ce site (notamment, les cours mis en ligne par APForm, le texte, les images et illustrations présentes ou à venir).</p><p class="fr-tag"><strong>4. Informations contenues dans le site</strong><br>Les informations présentées sur ce site ne sont pas exhaustives, elles sont communiquées à titre indicatif et sont susceptibles d\'évoluer ultérieurement. A ce titre, la responsabilité d\'APForm ne saurait être engagée de quelque manière que ce soit.</p><p class="fr-tag"><strong>5. Liens hypertextes</strong><br>La mise en place de liens hypertextes par des tiers vers des pages ou des documents diffusés sur notre site, pouvant de fait constituer une atteinte au droit d\'auteur, un acte relevant du parasitisme ou de la diffamation, doit faire l\'objet d\'une autorisation expresse d\'APForm. Par ailleurs, L\'association APForm ne saurait être tenue responsable pour le contenu ou les services offerts par des sites faisant un lien ou une référence non expressément autorisés au site d\'APForm.</p>'
        createdBy: admin._id
        createAt: new Date()
      appLog.info "CGU created for account: #{admin.profile.name}"
    # Check if cookie policy exists
    if BasicPages.find(slug: 'cookie').count() is 0
      appLog.info 'No cookie policy found. Creating default one.'
      BasicPages.insert
        title: 'Gestion des cookies'
        slug: 'cookie'
        body: '<p class="fr-tag"><strong>1. Qui sommes-nous ?</strong></p><p class="fr-tag">Bienvenue sur le site <a href="http://www.asv-la-soiree.com" rel="nofollow">http://www.asv-la-soiree.com</a> édité par <a href="http://apform.fr/" target="_blank" rel="nofollow">APForm</a>&nbsp;(consultez nos <a href="/cgu">mentions légales</a>).</p><p class="fr-tag">Cette rubrique est consacrée à notre politique de gestion des cookies. Elle vous permet d\'en savoir plus sur l\'origine et l\'usage des informations de navigation que les cookies peuvent enregistrer sur votre navigateur.</p><p class="fr-tag">Cette politique est donc importante pour vous, qui souhaitez avoir une expérience positive et confiante de nos services et pour nous, qui souhaitons répondre de manière précise et complète à vos questions sur l\'utilisation que nous faisons des cookies et tenir compte de vos souhaits.</p><p class="fr-tag">Lors de l\'affichage de nos contenus, des informations relatives à la navigation de votre terminal (ordinateur, tablette, smartphone, etc.) sont susceptibles d\'être enregistrées dans des fichiers Cookies installés sur votre terminal, sous réserve des choix que vous avez exprimés concernant les cookies et que vous pouvez modifier à tout moment (Cf. section 4).</p><p class="fr-tag"><strong>2. Qu\'est ce qu\'un cookie et à quoi sert-il ?</strong></p><p class="fr-tag">Un cookie (ou témoin de connexion) est un fichier texte susceptible d\'être enregistré, sous réserve de vos choix, dans un espace dédié du disque dur de votre terminal (ordinateur, tablette, smartphone, etc.) à l\'occasion de la consultation d\'un service en ligne grâce à votre logiciel de navigation. Il est transmis par le serveur d\'un site internet à votre navigateur. A chaque cookie est attribué un identifiant anonyme. Le fichier cookie permet à son émetteur d\'identifier le terminal dans lequel il est enregistré pendant la durée de validité ou d\'enregistrement du cookie concerné. Un cookie ne permet pas de remonter à une personne physique.</p><p class="fr-tag">Lorsque vous consultez le site <a href="http://www.asv-la-soiree.com" rel="nofollow">http://www.asv-la-soirée.com</a>&nbsp; nous pouvons être amenés à installer, sous réserve de votre choix, différents cookies : des cookies de performance.</p><p class="fr-tag"><strong>3. Type de cookie utilisés</strong></p><p class="fr-tag">Les Cookies que nous émettons sur notre site sont d\'une unique catégorie : la performance. Nous enregistrons des métriques nous permettant de vérifier la performance de nos services. Ces enregistrements sont parfaitement anonymes et s\'appuient sur les meilleures pratiques de confidentialité en vigueur. Aucune information relative à un individu ne peut en être extrait.</p><p class="fr-tag">Ce site utilise Google Analytics, un service d\'analyse de site internet fourni par Google Inc. Google Analytics utilise des cookies pour nous aider à analyser l\'utilisation du site par ses visiteurs. Les données générées par les cookies concernant votre utilisation du site (y compris votre adresse IP) seront transmises et stockées par Google sur des serveurs situés aux Etats- Unis. Nous utilisons cette information dans le but d\'évaluer votre utilisation du site, de compiler des rapports sur l\'activité du site et de fournir d\'autres services relatifs à l\'activité du site et à l\'utilisation d\'Internet. Vous pouvez obtenir plus d\'informations sur le service Google Analytics en consultant la page suivante :&nbsp;<a href="http://www.google.com/analytics/learn/privacy.html" target="_blank" rel="nofollow">http://www.google.com/analytics/learn/privacy.html</a></p><p class="fr-tag"><strong>4. Comment gérer vos cookies sur ce site</strong></p><p class="fr-tag">Vous pouvez paramétrer les cookies que nous utilisons via les modalités offertes par votre logiciel de navigation :</p><p class="fr-tag">Vous pouvez ainsi configurer votre logiciel de navigation de manière à ce que des cookies soient enregistrés dans votre terminal ou, au contraire, qu\'ils soient rejetés, soit systématiquement, soit selon leur émetteur. Vous pouvez également configurer votre logiciel de navigation de manière à ce que l\'acceptation ou le refus des cookies vous soient proposés ponctuellement, avant qu\'un cookie soit susceptible d\'être enregistré dans votre terminal.</p><p class="fr-tag">La gestion des cookies et de vos choix avec cette option est différente pour chacun d\'entre eux. Elle est décrite dans le menu d\'aide de votre navigateur, qui vous permettra de savoir de quelle manière modifier vos souhaits en matière de cookies.</p><p class="fr-tag">Nous mettons à votre disposition les liens des pages d\'informations vous permettant de configurer vous-même votre navigateur :</p><p class="fr-tag">Internet ExplorerTM : <a href="http://windows.microsoft.com/fr-FR/windows-vista/" target="_blank" rel="nofollow">http://windows.microsoft.com/fr-FR/windows-vista/</a></p><p class="fr-tag">Block-or-allow-cookies SafariTM : <a href="http://docs.info.apple.com/article.html?path=Safari/3.0/fr/9277.html" target="_blank" rel="nofollow">http://docs.info.apple.com/</a></p><p class="fr-tag">ChromeTM : <a href="http://support.google.com/chrome/bin/answer.py?hl=fr&amp;hlrm=en&amp;answer=95647" target="_blank" rel="nofollow">http://support.google.com/chrome/</a></p><p class="fr-tag">firefoxTM : <a href="http://support.mozilla.org/fr/kb/Activer%20et%20d%C3%A9sactiver%20les%20cookies" target="_blank" rel="nofollow">http://support.mozilla.org/fr/</a></p><p class="fr-tag">OperaTM : <a href="http://help.opera.com/Windows/10.20/fr/cookies.html">http://help.opera.com/Windows/10.20/fr/cookies.html</a></p><p class="fr-tag">Une fois vos préférences sauvegardées, nous n\'utiliserons en lecture ou en écriture que les cookies autorisés par vos règles. Tout cookie enregistré avant votre paramétrage sera toujours sur votre ordinateur, et vous pourrez également le supprimer dans les réglages de votre navigateur.</p><p class="fr-tag"><strong>5. Ce qu\'implique le refus des cookies</strong></p><p class="fr-tag">Si vous refusez l\'enregistrement de cookies dans votre terminal, ou si vous supprimez ceux qui y sont enregistrés, vous ne pourrez plus bénéficier d\'un certain nombre de fonctionnalités qui sont néanmoins nécessaires pour l\'utilisation de nos services.</p><p class="fr-tag">Tel serait le cas si vous tentiez d\'accéder à nos services qui nécessitent de vous reconnaitre. Tel serait également le cas lorsque nous ou nos prestataires ne pourrions pas définir, à des fins de compatibilité technique, le type de navigateur utilisé par votre terminal, ses paramètres de langue et d\'affichage ou le pays depuis lequel votre terminal semble connecté à Internet.</p><p class="fr-tag">Le cas échéant, le site <a href="http://www.asv-la-soiree.com" rel="nofollow">http://www.asv-la-soirée.com</a>&nbsp;décline toute responsabilité concernant les conséquences liées au fonctionnement dégradé de nos services résultant de l\'impossibilité d\'enregistrer ou de consulter les cookies nécessaires au fonctionnement du site et que vous auriez refusés ou supprimés.</p><p class="fr-tag"><strong>6. Si vous partagez l\'utilisation de votre terminal avec d\'autres personnes</strong></p><p class="fr-tag">Si votre terminal est utilisé par plusieurs personnes et lorsqu\'un même terminal dispose de plusieurs logiciels de navigation, nous ne pouvons pas nous assurer de manière certaine que les services destinés à votre terminal correspondent bien à votre propre utilisation de ce terminal et non à celle d\'un autre utilisateur de ce terminal. Le cas échéant, le partage avec d\'autres personnes de l\'utilisation de votre terminal et la configuration des paramètres de votre navigateur à l\'égard des cookies, relèvent de votre libre choix et de votre responsabilité.</p>'
        order: 2
        display: 3
        createdBy: admin._id
        createAt: new Date()
      appLog.info "Cookie policy created for account: #{admin.profile.name}"
  catch err
    appLog.error err.reason
  # Publish pages
  Meteor.publish 'basicpages', -> BasicPages.find()

# Using server side to start fast render
Router.configure
  waitOn: -> [ Meteor.subscribe 'basicpages']
  layoutTemplate: 'mainLayout'
  loadingTemplate: 'loading'

# Dynamic routes
pages = BasicPages.find().fetch()
# Static routes
appLog.info 'Defining route cgu'
Router.route '/cgu', ->
  @render 'nav', to: 'nav', data: ->
    _.sortBy (_.filter pages, (page) -> page.display is 1 or page.display is 2)
    , (page) -> page.order
  @render 'basicPage', data: -> BasicPages.findOne({slug: 'cgu'})
  @render 'footer', to: 'footer', data: ->
    _.sortBy (_.filter pages, (page) -> page.display is 1 or page.display is 3)
    , (page) -> page.order
, fastRender: true
appLog.info 'Defining route cookie'
Router.route '/cookie', ->
  @render 'nav', to: 'nav', data: ->
    _.sortBy (_.filter pages, (page) -> page.display is 1 or page.display is 2)
    , (page) -> page.order
  @render 'basicPage', data: -> BasicPages.findOne({slug: 'cookie'})
  @render 'footer', to: 'footer', data: ->
    _.sortBy (_.filter pages, (page) -> page.display is 1 or page.display is 3)
    , (page) -> page.order
, fastRender: true
appLog.info 'Defining route home'
Router.route '/', ->
  @render 'nav', to: 'nav', data: ->
    _.sortBy (_.filter pages, (page) -> page.display is 1 or page.display is 2)
    , (page) -> page.order
  @render 'home', data: -> pages
  @render 'footer', to: 'footer', data: ->
    _.sortBy (_.filter pages, (page) -> page.display is 1 or page.display is 3)
    , (page) -> page.order
, fastRender: true
# Not found routes
Router.route '/:unknown', ->
  @render 'nav', to: 'nav', data: ->
    _.sortBy (_.filter pages, (page) -> page.display is 1 or page.display is 2)
    , (page) -> page.order
  @render 'notFound'
  @render 'footer', to: 'footer', data: ->
    _.sortBy (_.filter pages, (page) -> page.display is 1 or page.display is 3)
    , (page) -> page.order
, fastRender: true
