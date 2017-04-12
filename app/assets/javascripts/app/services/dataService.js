
dataService.$inject = ["$http"];
function dataService($http) {
  var ctrl = this

  ctrl.getProductSummaries = function(search) {
    return $http({
      method: 'GET',
      url: '/product_summaries',
      params: {search: search}
    });
  };

  ctrl.createList = function(thing) {
    return $http.post('/shopping_lists', { shopping_list: thing })
  };

}

angular
.module('listmaker')
.service('dataService', dataService)
