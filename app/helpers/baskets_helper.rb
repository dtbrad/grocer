module BasketsHelper
  def sort_baskets_by(column, graph_config, title = column)
    title ||= column.titleize
    direction = column == @spending_state.sort_column && @spending_state.sort_direction == 'asc' ? 'desc' : 'asc'
    link_to title, baskets_path(sort_column: column, sort_direction: direction, start: graph_config.start_date,
                                end: graph_config.end_date, unit: graph_config.unit), remote: true
  end
end
