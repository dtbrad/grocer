class ListMailer < ActionMailer::Base
  default from: "from@example.com"

  def list_mailer(list)
    @list = list
    @user = list.user
    mail(to: @user.email, subject: 'Sample Email')
  end
end
