module ApplicationHelper

  def format_date(date)
    date.localtime.strftime("%A, %b %d %Y %l:%M %p")
  end

  def sortable(column, title=nil)
    title ||= column.titleize
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, sort: column, direction: direction
  end

end
