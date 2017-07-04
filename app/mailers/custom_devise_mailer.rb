require 'net/imap'

class CustomDeviseMailer < Devise::Mailer
  helper :application
  default template_path: 'devise/mailer'

  def confirmation_instructions(record, token, opts = {})
    my_mail = devise_mail(record, :confirmation_instructions, opts)
    target_mailbox = 'Sent Items'
    imap = Net::IMAP.new('mail.hover.com')
    imap.authenticate('PLAIN', ENV['hover_username'], ENV['hover_password'])
    imap.create(target_mailbox) unless imap.list('', target_mailbox)
    imap.append(target_mailbox, my_mail.to_s)
    imap.logout
    imap.disconnect
    super
  end
end
