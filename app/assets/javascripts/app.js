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
    url: "listmaker/lists/new",
    controller: "ListController as ctrl",
    templateUrl: "app/templates/list.html",
    resolve: {
      product_summaries: function (dataService) {
        return dataService.getProductSummaries();
      }
    }
  })
  .state('home.showList', {
    url: "listmaker/lists/:id",
    controller: "ShowListController as ctrl",
    templateUrl: "app/templates/showlist.html",
    resolve: {
      list: function($stateParams, dataService){
        return dataService.getList($stateParams.id);
      }
    }
  })
  .state('home.allLists', {
    url: "listmaker/lists",
    controller: 'ListsController as ctrl',
    templateUrl: "app/templates/lists.html",
    resolve: {
      lists: function (dataService) {
        return dataService.getLists();
      }
    }
  })
  $urlRouterProvider.otherwise("listmaker/lists")
  $locationProvider.html5Mode({
  enabled:true,
  requireBase: false
});
});
