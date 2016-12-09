$(document).on("turbolinks:load", function(){

  $('#basketsTable').tablesorter({
  	headers: {
      0: { sorter: 'shortdate' }
  	}
  });

  $('#basketTable').tablesorter();

  $('#productsTable').tablesorter({
    headers: {
      4: { sorter: 'shortdate' }
  	}
  });

  $('#productTable').tablesorter({
    headers: {
      0: { sorter: 'shortdate' }
  	}
  });

});
