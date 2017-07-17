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

  def product_monthly_purchasing
    line_chart current_user.line_items.where(product: @product)
      .group_by_month(:date, last: 18).sum('line_items.quantity'),
      ytitle: 'Quantity',
      title: 'Monthly Purchasing for ' + @product.nickname,
      colors: ['green'],
      library: {
        tooltip: { pointFormat: 'Total Qty Purchased: <b>{point.y}</b>', xDateFormat: '%B' }
      }
  end

  def product_weekly_purchasing
    line_chart current_user.line_items.where(product: @product)
      .group_by_week(:date, last: 78).sum('line_items.quantity'),
      ytitle: 'Quantity',
      title: 'Weekly Purchasing for ' + @product.nickname,
      colors: ['green'],
      library: {
        tooltip: { pointFormat: 'Total QTY Purchased: <b>{point.y}</b>', xDateFormat: 'Week of ' + '%m/%d/%y' }
      }
  end
end
