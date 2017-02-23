function ListController(product_summaries) {
  var ctrl = this
  ctrl.product_summaries = product_summaries.data
}

angular
.module('listmaker')
.controller('ListController', ListController)
