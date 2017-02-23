angular.module('listmaker', ['templates', 'ui.router'])
.config(function($locationProvider, $httpProvider, $stateProvider, $urlRouterProvider){
  $locationProvider.hashPrefix('')
  $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
  $stateProvider
  .state('home', {
    url: "/",
    templateUrl: "app/templates/home.html"
  })
  .state('home.newList', {
    url: "listmaker/new",
    controller: "ListController as ctrl",
    templateUrl: "app/templates/list.html",
    resolve: {
      product_summaries: function (dataService) {
        return dataService.getProductSummaries();
      }
    }
  })
  .state('home.allLists', {
    url: "listmaker/all",
    controller: 'ListsController as ctrl',
    templateUrl: "app/templates/lists.html"
  })
  $urlRouterProvider.otherwise("listmaker/all")
  $locationProvider.html5Mode({
  enabled:true,
  requireBase: false
});
});
