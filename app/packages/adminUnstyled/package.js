Package.describe({
  name: 'orionjs:admin-unstyled',
  summary: 'A simple theme for orion',
  version: '1.2.0',
  git: 'https://github.com/orionjs/orion'
});

Package.onUse(function(api) {
  api.versionsFrom('1.1.0.2');

  api.use([
    'meteor-platform',
    'coffeescript',
    'mquandalle:jade@0.4.3',
    'orionjs:core@1.2.0',
    'iron:layout@1.0.8',
    'aldeed:autoform@5.3.0',
    'aldeed:tabular@1.2.0',
    'pierreeric:useraccounts-creativepure@0.1.0'
  ]);

  api.imply([
    'orionjs:core',
    'iron:layout',
    'aldeed:autoform'
  ]);

  api.addFiles([
    'both/init.coffee',
    'both/tabular.coffee'
  ]);

  api.addFiles([
    // Layout
    'client/layout/layout.jade',
    'client/layout/layout.coffee',
    // Sidebar
    'client/sidebar/sidebar.jade',
    'client/sidebar/sidebar.coffee',
    // Login
    'client/accounts/orionCpLogin.tpl.jade',
    'client/accounts/orionCpRegisterWithInvitation.tpl.jade',
    // My account
    'client/accounts/orionCpAccountIndex.tpl.jade',
    'client/accounts/orionCpAccountPassword.tpl.jade',
    'client/accounts/orionCpAccountProfile.tpl.jade',
    // All accounts
    'client/accounts/orionCpAccountsIndex.tpl.jade',
    'client/accounts/orionCpAccountsCreate.tpl.jade',
    'client/accounts/orionCpAccountsUpdate.tpl.jade',
    'client/accounts/profile.coffee',
    // Config
    'client/config/orionCpConfigUpdate.tpl.jade',
    'client/config/update.coffee',
    // Dictionnary
    'client/dictionnary/orionCpDictionaryUpdate.tpl.jade',
    'client/dictionnary/update.coffee',
    // Collections
    'client/collections/orionCpCollectionsIndex.tpl.jade',
    'client/collections/orionCpCollectionsIndex.coffee',
    'client/collections/orionCpCollectionsCreate.tpl.jade',
    'client/collections/orionCpCollectionsCreate.coffee',
    'client/collections/orionCpCollectionsUpdate.tpl.jade',
    'client/collections/orionCpCollectionsUpdate.coffee',
    'client/collections/orionCpCollectionsDelete.tpl.jade',
    'client/collections/orionCpCollectionsDelete.coffee',
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
