angular.module('listmaker', ['angular-loading-bar','templates', 'ui.router', 'ngMessages'])
.config(["$locationProvider", "$httpProvider", "$stateProvider", "$urlRouterProvider", "$qProvider", function($locationProvider, $httpProvider, $stateProvider, $urlRouterProvider, $qProvider){
  $qProvider.errorOnUnhandledRejections(false)
  $locationProvider.hashPrefix('')
  $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
  $stateProvider
  .state('home', {
    url: "/",
    templateUrl: "app/templates/home.html"
  })
  .state('home.newList', {
    url: "listmaker/lists/new",
    controller: "ListController as ctrl",
    templateUrl: "app/templates/list.html",
    resolve: {
      product_summaries: ["dataService", function (dataService) {
        return dataService.getProductSummaries();
      }]
    }
  })
  $urlRouterProvider.otherwise("listmaker/lists/new")
  $locationProvider.html5Mode({
    enabled:true,
    requireBase: false
  });

}]);
