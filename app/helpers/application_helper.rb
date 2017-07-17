module ApplicationHelper
  def format_date(date)
    date.localtime.strftime('%A, %b %d %Y %l:%M %p')
  end

  def form_date(date)
    date.localtime.strftime('%Y-%m-%d')
  end

  def sort_record_by(column, title = nil)
    # binding.pry
    title ||= column.titleize
    direction = column == sort_column && sort_direction == 'asc' ? 'desc' : 'asc'
    link_to title, sort: column, direction: direction, remote: true
  end
end
