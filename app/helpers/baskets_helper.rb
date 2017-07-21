module BasketsHelper
  def sort_baskets_by(column, graph_config, title = column)
    title ||= column.titleize
    # binding.pry
    direction = column == @spending_state.sort_column && @spending_state.sort_direction == 'asc' ? 'desc' : 'asc'
    link_to title, baskets_path(sort_column: column, sort_direction: direction, start: graph_config.start_date,
                                end: graph_config.end_date, unit: graph_config.unit), remote: true
  end

  def freq_formatter(num)
    if num == 10_000
      ''
    elsif !num
      'You did not shop during the selected time period. '
    elsif num == 1
      'When active during this period you shopped on average every day. '
    else
      "When active during this period you shopped on average every #{num} days. "
    end
  end

  def avg_formatter(num)
    "Your average total per trip during this time was #{num}." if num
  end
end
