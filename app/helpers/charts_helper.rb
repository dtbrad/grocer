module ChartsHelper
  def monthly_spending
    line_chart current_user.baskets.group_by_month(:date, last: 12, current: false).sum('baskets.total_cents / 100'),
      title: 'Monthly Spending For Last Year',
      colors: ['green'],
      library: {
        yAxis: {
             labels: {
                 format: '${value}'
             }
         },
            tooltip: {
              pointFormat: 'Total Spent: <b>{point.y}</b>',
              xDateFormat: '%B',
              valuePrefix: '$'
            }
          }
  end

  def weekly_spending
    line_chart current_user.baskets.group_by_week(:date, last: 56, current: false).sum('baskets.total_cents / 100'),
      title: 'Weekly Spending For Last Year',
      colors: ['brown'],
      library: {
        yAxis: {
             labels: {
                 format: '${value}'
             }
         },
            tooltip: {
              pointFormat: 'Total Spent: <b>{point.y}</b>',
              xDateFormat: '',
              valuePrefix: '$'
            }
          }
  end

  def most_spent
    column_chart current_user.products.most_money_spent,
    title: "Top Ten Products (By Total Dollars Spent)",
    colors: ['green'],
    lang: {
        decimalPoint: ',',
        thousandsSep: '.'
      },
    library: {
      yAxis: {
           labels: {
               format: '${value}'
           }
       },
          tooltip: {
            pointFormat: 'Total Spent: <b>{point.y}</b>',
            valuePrefix: '$'
          }
        }
  end

  def most_bought
    column_chart current_user.products.most_purchased,
    title: "Top Ten Products (By Total Quantity Purchased)",
    colors: ['brown'],
    library: {
      tooltip: {
        pointFormat: 'Times Bought: <b>{point.y}</b>'
            # valuePrefix: '$'
      }
    }
  end

end
