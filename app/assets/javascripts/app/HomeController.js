function HomeController(){
  var ctrl = this

  ctrl.dan = "Daniel"

}

angular
.module('listmaker')
.controller('HomeController', HomeController)
