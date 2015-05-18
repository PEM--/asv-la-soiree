Template.orionBootstrapCollectionsIndex.events({
  'click tr': function(event) {
    if (!$(event.target).is('td')) return;
    var collection = Template.currentData().collection;
    var dataTable = $(event.target).closest('table').DataTable();
    var rowData = dataTable.row(event.currentTarget).data();
    if (rowData) {
      if (rowData.canShowUpdate()) {
        var path = collection.updatePath(rowData);
        Router.go(path);
      }
    }
  }
});

Template.orionBootstrapCollectionsIndex.onRendered(function() {
  this.autorun(function () {
    Template.currentData();
    Session.set('orionBootstrapCollectionsIndex_showTable', false);
    Meteor.defer(function () {
      Session.set('orionBootstrapCollectionsIndex_showTable', true);
    });
  });
})

Template.orionBootstrapCollectionsIndex.helpers({
  showTable: function () {
    return Session.get('orionBootstrapCollectionsIndex_showTable');
  }
});