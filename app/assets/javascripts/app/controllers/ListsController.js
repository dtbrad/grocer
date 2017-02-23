
ListsController.$inject = ["$state", "$stateParams", "lists"];function ListsController($state, $stateParams, lists) {
  var ctrl = this
  ctrl.lists = lists.data

  ctrl.seeList = function(list){
    $state.go('home.showList', {id: list.id});
  }
}

angular
.module('listmaker')
.controller('ListsController', ListsController)
