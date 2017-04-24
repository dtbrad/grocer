class ApplicationMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)
  default from: ENV['hover_username']
  layout 'mailer'
end
