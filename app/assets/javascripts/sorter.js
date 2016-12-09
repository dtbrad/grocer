$(document).on("turbolinks:load", function(){
  $('table').tablesorter({
  	  headers: {
  	    0: {
  	      sorter: 'shortdate',
          theme : 'blue',
          cssInfoBlock : "avoid-sort", 
  	    }
  	  }
  	});

});
