require 'net/imap'

class UpdateMailer < ActionMailer::Base
  default from: "'Latest Grocer Updates' <latest@updates.my-grocer.com>"
  add_template_helper(ApplicationHelper)

  def update_mailer(user)
    attachments.inline['grocer_title.jpg'] = File.read('public/images/grocer_title.jpg')
    @user = user
    my_mail = mail(to: @user.email, subject: 'Some Updates to Grocer')
    target_mailbox = 'Sent Items'
    imap = Net::IMAP.new('mail.hover.com')
    imap.authenticate('PLAIN', ENV['hover_username'], ENV['hover_password'])
    imap.create(target_mailbox) unless imap.list('', target_mailbox)
    imap.append(target_mailbox, my_mail.to_s)
    imap.logout
    imap.disconnect
  end
end
