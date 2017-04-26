require 'net/imap'

class ListMailer < ActionMailer::Base
  default from: ENV['hover_username']
  add_template_helper(ApplicationHelper)

  def list_mailer(list)
    @list = list
    @user = list.user
    my_mail = mail(to: @user.email, subject: 'Your Shopping List')
    target_mailbox = 'Sent Items'
    imap = Net::IMAP.new("mail.hover.com")
    imap.authenticate('PLAIN', ENV['hover_username'], ENV['hover_password'])
    imap.create(target_mailbox) unless imap.list('', target_mailbox)
    imap.append(target_mailbox, my_mail.to_s)
    imap.logout
    imap.disconnect
  end
end
