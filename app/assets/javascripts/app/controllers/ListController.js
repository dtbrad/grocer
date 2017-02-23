
ListController.$inject = ["$state", "$stateParams", "product_summaries", "dataService"];function ListController($state, $stateParams, product_summaries, dataService) {
  var ctrl = this
  ctrl.product_summaries = product_summaries.data
  ctrl.search = ""
  ctrl.list = [];
  ctrl.newItem = {};

  ctrl.addToList = function(item){
    if((ctrl.listForm.manualSearchName.$valid && ctrl.listForm.manualSearchPrice.$valid) || item.$$hashKey ) {
    delete item.$$hashKey
    item.quantity = 1;
    ctrl.list.push(item);
    ctrl.search = "";
  }
  }

  ctrl.remove = function(item, arr){
    arr.splice(arr.indexOf(item), 1)
  }

  ctrl.listTotal = function(){
      var total = 0;
      for(var i = 0; i < ctrl.list.length; i++){
          var item = ctrl.list[i];
          total += (item.quantity * item.price);
      }
      return total;
  }

  ctrl.createList = function(){
    ctrl.list.forEach(function(x){ x.quantity = parseFloat(x.quantity); x.price = parseFloat(x.price)})
    var list = {name: ctrl.listTitle, items_attributes: ctrl.list}
    dataService.createList(list)
    .then(function(result){
      $state.go('home.showList', {id: result.data.id});
    })
  }

}

angular
.module('listmaker')
.controller('ListController', ListController)
