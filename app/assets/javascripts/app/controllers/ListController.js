
ListController.$inject = ["$state", "$stateParams", "product_summaries", "dataService", "$window", "$timeout"];function ListController($state, $stateParams, product_summaries, dataService, $window, $timeout) {
  var ctrl = this
  ctrl.product_summaries = product_summaries.data
  ctrl.list = [];
  ctrl.newItem = {};


  ctrl.addToList = function(item){
    if((ctrl.listForm.manualSearchName.$valid && ctrl.listForm.manualSearchPrice.$valid) || item.$$hashKey ) {
      delete item.$$hashKey
      item.quantity = 1;
      item.name = item.nickname || item.name
      ctrl.list.push(item);
      ctrl.search = "";
      ctrl.newItem = {};
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
    if(ctrl.listForm.$valid && ctrl.list.length > 0) {
      ctrl.list.forEach(function(x){ x.quantity = parseFloat(x.quantity); x.price = parseFloat(x.price)})
      var list = {items_attributes: ctrl.list}
      dataService.createList(list)
      .then(function(result){
        setTimeout(function() {
        if(result.data.user.email === "sampleuser@mail.com"){
          Command: toastr["info"]('If you do this with a live account, your list will be saved and emailed to you.');
        }
       else {
         Command: toastr["info"]('Your list has been saved and emailed to ' + result.data.user.email);
       }
       $timeout(function(){window.location.href = '/shopping_lists'}, 3000);
      });
    });
  }

}
};

angular
.module('listmaker')
.controller('ListController', ListController)
