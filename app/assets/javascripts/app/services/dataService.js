function dataService($http) {
  var ctrl = this

  ctrl.getProductSummaries = function() {
    return $http.get('/product_summaries')
  }
}

angular
.module('listmaker')
.service('dataService', dataService)
