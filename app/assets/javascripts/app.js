angular.module('listmaker', ['angular-loading-bar','templates', 'ngMessages'])
.config(["$locationProvider", "$httpProvider", function($locationProvider, $httpProvider){
  $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
  $locationProvider.html5Mode({
    enabled:true,
    requireBase: false
  });

}]);
