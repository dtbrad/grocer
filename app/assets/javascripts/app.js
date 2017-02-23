angular.module('listmaker', ['templates', 'ui.router'])
.config(function($locationProvider, $httpProvider, $stateProvider, $urlRouterProvider){
  $locationProvider.hashPrefix('')
  $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
  $stateProvider
  .state('home', {
    url: "",
    templateUrl: "app/templates/home.html"
  })
  .state('home.newList', {
    url: "/newlist",
    templateUrl: "app/templates/list.html"
  })
  .state('home.allLists', {
    url: "/lists",
    templateUrl: "app/templates/lists.html"
  })
  $urlRouterProvider.otherwise("/lists")
});
