$(document).ready(function() {
  var $chartData = $("#product-history-chart")
  if($chartData.data('param1') != undefined) {
  var formatted_array = $chartData.data('param1').map(function(x) {
    return [Date.parse(x[0]), x[1]]
  })

  var unit = $chartData.data('param2');
  var for_graph = right_date(unit);
  var product_id = $chartData.data('param3');
  var url = $chartData.data('param4');

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

  Highcharts.chart('product-history-chart', {

      chart: { renderTo: 'products-spending-chart', type: 'spline' },
      title: {
          text: ''
      },
      yAxis: {
        allowDecimals: false,
        title: {
            text: 'Qty'
        }
      },
      xAxis: {
       type: 'datetime',
       title: {
           text: 'Date'
       }
      },
      series: [{
          name: 'Total Purchased',
          data: formatted_array
      }],
      tooltip: {
                  formatter: function() {
                              return Highcharts.dateFormat(for_graph, new Date(this.x)) + ' - purchased '  + this.y + ' ' +(this.y > 1 ? 'times' : 'time')
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
                url: url + '/products/' + product_id,
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

});
