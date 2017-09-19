require 'net/imap'

class AutoforwardMailer < ApplicationMailer
  include MessageHelper
  default from: ENV['hover_username']
  add_template_helper(ApplicationHelper)

  def autoforward_mailer(string_containing_sender)
    @sender_email = extract_email(string_containing_sender)
    my_mail = mail(to: @sender_email, subject: 'Grocer email confirmed, now make a forwarding filter!')
    target_mailbox = 'Sent Items'
    imap = Net::IMAP.new('mail.hover.com')
    imap.authenticate('PLAIN', ENV['hover_username'], ENV['hover_password'])
    imap.create(target_mailbox) unless imap.list('', target_mailbox)
    imap.append(target_mailbox, my_mail.to_s)
    imap.logout
    imap.disconnect
  end
end
