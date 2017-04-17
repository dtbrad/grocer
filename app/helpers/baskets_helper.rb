module BasketsHelper

  def sort_baskets_by(column, start_date, end_date, unit, title=column)
    title ||= column.titleize
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, baskets_path(graph_chart: false, sort: column, direction: direction, unit: unit, start_date: revised_start, end_date: revised_end), :remote => true
  end

  def freq_formatter(num)
    if num == 10000
      ""
    elsif !num
      "You did not shop during the selected time period. "
    elsif num == 1
      "When active during this period you shopped on average every day. "
    else
      "When active during this period you shopped on average every #{num} days. "
    end
  end

  def avg_formatter(num)
    "Your average total per trip during this time was #{num}." unless !num
  end


end
