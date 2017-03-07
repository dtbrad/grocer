function saneNumbers() {
  return {
      restrict: 'A',
      require: 'ngModel',
      link: function (scope, element, attrs, ngModel) {
        ngModel.$validators.saneNumbers = function (value) {
          if (value === undefined) {
            return true
          }
          return value < 200;
  			};
  		}
  	}
  }

angular
    .module('listmaker')
    .directive('saneNumbers', saneNumbers);
