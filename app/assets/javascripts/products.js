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
                    },
                    legendItemClick: function () {
                      return false
                  }
                    }
                  }
                },
          credits: {
        enabled: false
        },
      });
  }

  // Products Index Chart

  var $productsSpendingData = $("#products-spending-chart")
  var $productsPurchasedData = $("#products-purchased-chart")
  if($productsSpendingData.data('param1') != undefined) {

    var spending_data = $productsSpendingData.data('param1').map(function(x){
      return {name: x[0], y: Number(x[1]), id: x[2]}
    })
    var purchasing_data = $productsPurchasedData.data('param1').map(function(x){
      return {name: x[0], y: x[1], id: x[2]}
    })
    var url = $productsSpendingData.data('param2');

    $('#products-purchased-chart').hide();

    $('#products-toggle').on('click', function(){
      if( $('#products-purchased-chart').is( ':visible' ) ) {
        $('#products-purchased-chart').hide();
        $('#products-spending-chart').show();
      }
      else {
        $('#products-spending-chart').hide();
        $('#products-purchased-chart').show();
        productsPurchasedChart.reflow();
      }
    })

    Highcharts.chart('products-purchased-chart', {
        chart: {
            type: 'column'
          },
          title: {
            text: 'Top Ten Products by Qty Purchased'
          },
          xAxis: {
                categories: $productsPurchasedData.data('param1').map(function(x){
                  return x[0];
                })
              },
              yAxis: {
                labels: {format: '{value}'},
                title: {
                  text: 'Quantity'
                }
              },
              tooltip: {
                pointFormat: 'Total Purchased: <b>{point.y}</b>'
              },
              plotOptions: {
                series: {
                  cursor: 'pointer',
                  events: { click:  function (event) {
                                      location.href = url + '/products/' + event.point.id;
                                    }
                          }
                }
              },
              series: [
                { data: purchasing_data,
                  name: "Total Purchased", color: 'blue'},
              ],
              credits: {
                enabled: false
              }
            });

            Highcharts.chart('products-spending-chart', {
              chart: {
                type: 'column'
              },
              title: {
                text: 'Top Ten Products by Money Spent'
              },
              xAxis: {
                categories: $productsSpendingData.data('param1').map(function(x){
                  return x[0];
                })
              },
              yAxis: {
                labels: {format: '${value}'},
                title: {
                  text: 'Dollar Amount'
                }
              },
              tooltip: {
                pointFormat: 'Total Spent: <b>{point.y}</b>', valuePrefix: '$'
              },
              plotOptions: {
                series: {
                  cursor: 'pointer',
                  events: { click:  function (event) {
                                      location.href = url + '/products/' + event.point.id;
                                    }
                          }
                }
              },
              series: [
                { data: spending_data,
                  name: "Total Spent", color: 'green'},
              ],
              credits: {
                enabled: false
              },
            });
  }
});
