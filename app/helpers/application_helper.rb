module ApplicationHelper

  def format_date(date)
    date.localtime.strftime("%A, %b %d %Y %l:%M %p")
  end

end
