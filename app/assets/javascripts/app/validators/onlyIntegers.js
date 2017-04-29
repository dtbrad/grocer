function onlyIntegers() {
  return {
      restrict: 'A',
      require: 'ngModel',
      link: function (scope, element, attrs, ngModel) {
        if(scope.item.has_weight == false) {
          ngModel.$validators.onlyIntegers = function (value) {
            if (value === undefined) {
              return true
            }
            return (/^-?[0-9][^\.]*$/).test(value);
    			};
        }
  		}
  	}
  }

angular
    .module('listmaker')
    .directive('onlyIntegers', onlyIntegers);
