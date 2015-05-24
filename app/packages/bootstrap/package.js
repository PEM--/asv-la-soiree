Package.describe({
  name: 'orionjs:bootstrap',
  summary: 'A simple theme for orion',
  version: '1.0.3',
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
    'aldeed:autoform@5.2.0',
    'aldeed:tabular@1.2.0',
    //'useraccounts:unstyled@1.10.0',
    'pierreeric:useraccounts-creativepure@0.1.0',
    'zimme:iron-router-active@1.0.4',

    ]);

  api.imply([
    'orionjs:core',
    'iron:layout',
    'aldeed:autoform',
    'useraccounts:bootstrap',
    'zimme:iron-router-active'
    ]);

  api.addFiles([
    'both/init.coffee',
    'both/tabular.coffee'
  ]);

  api.addFiles([
    'views/layout/layout.html',
    'views/layout/layout.js',
    'views/sidebar/sidebar.html',
    // 'views/accounts/login.html',
    // 'views/accounts/register-with-invitation.html',
    // 'views/accounts/index.html',
    // 'views/accounts/password.html',
    // 'views/accounts/profile.html',
    // 'views/accounts/profile.js',
    // 'views/accounts/accounts.html',
    // 'views/accounts/roles.html',
    // 'views/accounts/invite.html',
    'views/config/update.html',
    'views/config/update.js',
    'views/dictionary/update.html',
    'views/dictionary/update.js',
    'views/collections/index.html',
    'views/collections/index.js',
    'views/collections/create.html',
    'views/collections/create.js',
    'views/collections/update.html',
    'views/collections/update.js',
    'views/collections/delete.html',
    'views/pages/index.html',
    'views/pages/create.html',
    'views/pages/update.html',
    'views/pages/delete.html',
    'views/pages/pages.js',
    'client/accounts/orionBootstrapAccountIndex.tpl.jade',
    'client/accounts/orionBootstrapAccountsIndex.tpl.jade',
    'client/accounts/orionBootstrapAccountPassword.tpl.jade',
    'client/accounts/orionBootstrapAccountProfile.tpl.jade',
    'client/accounts/orionBootstrapAccountsInvite.tpl.jade',
    'client/accounts/orionBootstrapAccountsUpdateRoles.tpl.jade',
    'client/accounts/orionBootstrapLogin.tpl.jade',
    'client/accounts/orionBootstrapRegisterWithInvitation.tpl.jade',
    'client/accounts/profile.coffee',
    ], 'client');

  api.export('orion');
});

Package.onTest(function(api) {
  api.use('tinytest');
  api.use('orionjs:core');
});
