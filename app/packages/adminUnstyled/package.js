Package.describe({
  name: 'orionjs:admin-unstyled',
  summary: 'A simple theme for orion',
  version: '1.0.0',
  git: 'https://github.com/orionjs/orion'
});

Package.onUse(function(api) {
  api.versionsFrom('1.1.0.2');

  api.use([
    'meteor-platform',
    'coffeescript',
    'mquandalle:jade@0.4.3',
    'orionjs:core@1.0.0',
    'iron:layout@1.0.7',
    'aldeed:autoform@5.3.0',
    'aldeed:tabular@1.2.0',
    'pierreeric:useraccounts-creativepure@0.1.0',
    'zimme:iron-router-active@1.0.4'
  ]);

  api.imply([
    'orionjs:core',
    'iron:layout',
    'aldeed:autoform',
    'zimme:iron-router-active'
  ]);

  api.addFiles([
    'both/init.coffee',
    'both/tabular.coffee'
  ]);

  api.addFiles([
    // Layout
    'client/layout/layout.jade',
    'client/layout/layout.coffee',
    'client/sidebar/sidebar.jade',
    // My account
    'client/accounts/orionCpAccountIndex.tpl.jade',
    'client/accounts/orionCpAccountPassword.tpl.jade',
    'client/accounts/orionCpAccountProfile.tpl.jade',
    'client/accounts/orionCpLogin.tpl.jade',
    'client/accounts/orionCpRegisterWithInvitation.tpl.jade',
    // All accounts
    'client/accounts/orionCpAccountsIndex.tpl.jade',
    'client/accounts/orionCpAccountsInvite.tpl.jade',
    'client/accounts/orionCpAccountsUpdateRoles.tpl.jade',
    'client/accounts/profile.coffee',
    // Config
    'client/config/orionCpConfigUpdate.tpl.jade',
    'client/config/update.coffee',
    // Dictionnary
    'client/dictionnary/orionCpDictionaryUpdate.tpl.jade',
    'client/dictionnary/update.coffee',
    // Collections
    'client/collections/orionCpCollectionsCreate.tpl.jade',
    'client/collections/orionCpCollectionsDelete.tpl.jade',
    'client/collections/orionCpCollectionsIndex.tpl.jade',
    'client/collections/orionCpCollectionsUpdate.tpl.jade',
    'client/collections/collections.coffee',
    // Pages
    // 'client/pages/orionCpPagesCreate.tpl.jade',
    // 'client/pages/orionCpPagesDelete.tpl.jade',
    // 'client/pages/orionCpPagesIndex.tpl.jade',
    // 'client/pages/orionCpPagesUpdate.tpl.jade',
    // 'client/pages/pages.coffee',
  ], 'client');

  api.export('orion');
});

Package.onTest(function(api) {
  api.use('tinytest');
  api.use('orionjs:core');
});
