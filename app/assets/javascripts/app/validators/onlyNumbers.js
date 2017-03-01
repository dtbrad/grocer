function onlyNumbers() {
  return {
      restrict: 'A',
      require: 'ngModel',
      link: function (scope, element, attrs, ngModel) {
        ngModel.$validators.onlyNumbers = function (value) {
          if (value === undefined) {
            return true
          }
          return (/^[+]?\d+([.]\d+)?$/).test(value);
  			};
  		}
  	}
  }

angular
    .module('listmaker')
    .directive('onlyNumbers', onlyNumbers);
