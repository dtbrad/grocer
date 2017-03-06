// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap-sass
//= require toastr
//= require highcharts
//= require chartkick
//= require angular
//= require angular-rails-templates
//= require angular-ui-router
//= require angular-messages
//= require bootstrap-datepicker
//= require angular-loading-bar
//= require_tree

$(document).ready(function() {
	matchHeight();
	$("#textfield_id").attr('readOnly', 'true')
		$('.datepicker').datepicker({
    	format: 'yyyy-mm-dd',
    	endDate: '-0d'
	});

	function matchHeight(){
  var heights = $('.even').map(function() {
    return $(this).height();
    }).get(),
    maxHeight = Math.max.apply(null, heights);
   $('.even').height(maxHeight);
}

$('.welcomebutton').click(function(){
    $(this).text(function(i,old){
      return old=='Read more »' ?  'Read less' : 'Read more »';
    });
});

	 toastr.options = {
	                  "closeButton": true,
	                  "debug": false,
	                  "positionClass": "toast-top-full-width",
	                  "onclick": null,
	                  "showDuration": "1000",
	                  "hideDuration": "1000",
	                  "timeOut": "3000",
	                  "extendedTimeOut": "1000",
	                  "showEasing": "swing",
	                  "hideEasing": "linear",
	                  "showMethod": "fadeIn",
	                  "hideMethod": "fadeOut"
	              }

	});
