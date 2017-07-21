module ApplicationHelper
  def format_date(date)
    date = date.class == String ? DateTime.parse(date) : date
    date.localtime.strftime('%A %b %d, %Y %l:%M %p')
  end

  def short_format_date(date)
    date = date.class == String ? DateTime.parse(date) : date
    date.localtime.strftime('%B %d, %Y')
  end

  def form_date(date)
    date = date.class == String ? DateTime.parse(date) : date
    date.localtime.strftime('%Y-%m-%d')
  end

  def sort_products_record_by(column, title = nil)
    title ||= column.titleize
    direction = column == sort_column && sort_direction == 'asc' ? 'desc' : 'asc'
    link_to title, products_path(sort: column, direction: direction), remote: true
  end

  def sort_line_item_record_by(column, graph_config, title = nil)
    title ||= column.titleize
    direction = column == sort_column && sort_direction == 'asc' ? 'desc' : 'asc'
    link_to title, product_path(@product, sort: column, direction: direction, start: graph_config.start_date,
                                          end: graph_config.end_date, unit: graph_config.unit), remote: true
  end

  def sort_column
    params[:sort]
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end
end
