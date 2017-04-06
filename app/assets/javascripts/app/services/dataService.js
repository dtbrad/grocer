
dataService.$inject = ["$http"];function dataService($http) {
  var ctrl = this

  ctrl.getProductSummaries = function() {
    return $http.get('/product_summaries')
  }

  ctrl.createList = function(thing) {
    return $http.post('/shopping_lists', { shopping_list: thing })
  };

}

angular
.module('listmaker')
.service('dataService', dataService)
