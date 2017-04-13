module BasketsHelper

  def sort_baskets_by(column, unit, duratio, title=column)
    title ||= column.titleize
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, baskets_path(graph_chart: false, sort: column, direction: direction, unit: unit, duration: duration), :remote => true
  end

end
