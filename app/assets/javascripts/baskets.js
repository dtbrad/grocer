$(document).ready(function() {
	$('#textfield_id').attr('readOnly', 'true');
	$('.datepicker').datepicker({
		format: 'yyyy-mm-dd',
		endDate: '-0d'
	});

	var $chartData = $("#danielchart")

	if($chartData.data('param1') != undefined) {
	var formatted_array = $chartData.data('param1').map(function(x) {
		return [Date.parse(x[0]), x[1]]
	})

	formatted_array = $chartData.data('param1').map(function(x) {
		return [Date.parse(x[0]), x[1]]
	})
	var unit = $chartData.data('param2');
	var for_graph = right_date(unit);

	function right_date(unit) {
		if (unit == 'month') {
		 return '%b %Y'
		}
		else if (unit == 'week') {
			return 'week of %b %e, %Y'
		}
		else {
			return '%b %e, %Y'
		}
	}

	Highcharts.chart('danielchart', {

			chart: { renderTo: 'danielchart', type: 'spline' },
			title: {
					text: 'Spending History'
			},
			yAxis: {
				title: {
						text: 'Amount Spent'
				},
				labels: {
				format: '${value}'
				}
			},
			xAxis: {
			 type: 'datetime',
			 title: {
					 text: 'Date'
			 }
			},
			series: [{
					name: 'spending',
					data: formatted_array
			}],
			tooltip: {
									formatter: function() {
															return Highcharts.dateFormat(for_graph, new Date(this.x)) + ' - $'  + (this.y / 100)
														 }
							},
			plotOptions: {
				series: {
					cursor: 'pointer',
					events: { click:  function (event) {
						if (unit === "week" || unit === "month" ) {

							var date = new Date(event.point.x).toString()
							var new_unit = unit === "month" ? "week" : "day"

							$.ajax({
								url: 'http://localhost:3000/baskets',
								jsonp: 'refreshSection',
								dataType: "jsonp",
								data: { "graph_change": "yes", "tooltip_date": date, "tooltip_unit": new_unit, "graph_change": "yes" }
							});
										}
										}
									}
								}
							},
				credits: {
			enabled: false
			},
	});
}

	$('.welcomebutton').click(function() {
		$(this).text(function(i, old) {
			return old == 'Read more »' ? 'Read less' : 'Read more »';
		});
	});

	$('#import_baskets_date_submit').click(function(r) {
		var date = $('#import_baskets_date_id').val();
		if (date === '') {
			r.preventDefault();
			$('.new-basket-error').show();
			setTimeout(function() {
				$('.new-basket-error').hide();
			}, 5000);
		}
	});

	toastr.options = {
		closeButton: true,
		debug: false,
		positionClass: 'toast-top-full-width',
		onclick: null,
		showDuration: '1000',
		hideDuration: '1000',
		timeOut: '3000',
		extendedTimeOut: '1000',
		showEasing: 'swing',
		hideEasing: 'linear',
		showMethod: 'fadeIn',
		hideMethod: 'fadeOut'
	};

	if (!('ontouchstart' in document.documentElement)) {
		$('[data-toggle="popover"]').popover();
	}
});
