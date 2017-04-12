ListController.$inject = ["dataService", "$window", "$timeout"];
function ListController(dataService, $window, $timeout) {
  var ctrl = this
  ctrl.list = [];
  ctrl.newItem = {};
  ctrl.searchResultsArray = []

  ctrl.populateArray = function (search) {
    console.log(search);
    if(search.length > 0) {
      dataService.getProductSummaries(search)
      .then(function(response){
        ctrl.searchResultsArray = response.data;
      });
    }
    else {
      ctrl.searchResultsArray = [];
    }
  };

  ctrl.addToList = function(item){
    if((ctrl.listForm.manualSearchName.$valid && ctrl.listForm.manualSearchPrice.$valid) || item.$$hashKey ) {
      delete item.$$hashKey
      item.quantity = 1;
      item.name = item.nickname || item.name
      ctrl.list.push(item);
      ctrl.newItem = {};
      ctrl.result = "";
      ctrl.searchResultsArray = [];
    }
  };

  ctrl.remove = function(item, arr){
    arr.splice(arr.indexOf(item), 1)
  };

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
         Command: toastr["info"]('Your list is being saved and emailed to ' + result.data.user.email);
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
