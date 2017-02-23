function ShowListController(list) {
  var ctrl = this;
  ctrl.list = list.data;
}

angular
.module('listmaker')
.controller('ShowListController', ShowListController);
