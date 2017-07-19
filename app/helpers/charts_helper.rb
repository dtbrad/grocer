module ChartsHelper
  def basket_spending(obj)
    date_unit = proper_date_unit(obj.unit)
    line_chart current_user.baskets.group_baskets(obj),
      ytitle: 'Total Spent',
      colors: ['green'],
      library: {
        yAxis: {
          labels: { format: '${value}' }
        },
        tooltip: { pointFormat: 'Total Spent: <b>{point.y}</b>', xDateFormat: date_unit, valuePrefix: '$' }
      }
  end

  def product_spending(collection, obj)
    date_unit = proper_date_unit(obj.unit)
    line_chart collection.group_line_items(obj),
      ytitle: 'Qty Purchased',
      colors: ['green'],
      library: {
        yAxis: {
          labels: { format: '{value}' }
        },
        tooltip: { pointFormat: 'Qty Bought: <b>{point.y}</b>', xDateFormat: date_unit }
      }
  end

  def proper_date_unit(unit)
    if unit == 'month'
      '%B'
    elsif unit == 'weeks'
      'Week of ' + '%m/%d/%y'
    else
      '%a, %b %d %Y'
    end
  end

  def most_spent
    column_chart current_user.products.most_money_spent,
      ytitle: 'Total Spent',
      title: 'Top Ten Products (By Total Dollars Spent)',
      colors: ['green'],
      lang: { decimalPoint: ',', thousandsSep: '.' },
      library: {
        yAxis: { labels: { format: '${value}' } },
        tooltip: { pointFormat: 'Total Spent: <b>{point.y}</b>', valuePrefix: '$' }
      }
  end

  def most_bought
    column_chart current_user.products.most_purchased,
      ytitle: 'Qty Bought',
      title: 'Top Ten Products (By Total Quantity Purchased)',
      colors: ['brown'],
      library: {
        tooltip: {
          pointFormat: 'Times Bought: <b>{point.y}</b>'
        }
      }
  end
end
