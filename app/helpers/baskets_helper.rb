module BasketsHelper

  def sort_baskets_by(column, unit, duratio, title=column)
    title ||= column.titleize
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, baskets_path(graph_chart: false, sort: column, direction: direction, unit: unit, duration: duration), :remote => true
  end

  def freq_formatter(num)
    if num == 10000
      ""
    elsif !num
      "You did not shop during the selected time period. "
    elsif num == 1
      "During the selected time period you shopped on average every day. "
    else
      "During the selected time period you shopped on average every #{num} days. "
    end
  end

  def avg_formatter(num)
    "Your average total per trip during this time was #{num}." unless !num
  end


end
