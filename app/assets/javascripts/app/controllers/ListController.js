function ListController($state, product_summaries) {
  var ctrl = this
  ctrl.product_summaries = product_summaries.data
  ctrl.search = ""
  ctrl.list = [];
  ctrl.newItem = {};

  ctrl.addToList = function(item){
    delete item.$$hashKey
    item.quantity = 1;
    ctrl.list.push(item);
    ctrl.search = "";
    ctrl.newItem = {};
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
    console.log("list created")
    $state.go('home.allLists');
  }

}

angular
.module('listmaker')
.controller('ListController', ListController)
