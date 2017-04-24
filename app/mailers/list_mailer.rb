class ListMailer < ActionMailer::Base
  default from: ENV['hover_username']
  add_template_helper(ApplicationHelper)

  def list_mailer(list)
    @list = list
    @user = list.user
    mail(to: @user.email, subject: 'Your Shopping List')
  end
end
