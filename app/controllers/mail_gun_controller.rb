class MailGunController < ApplicationController
  skip_before_action :verify_authenticity_token

  def process_mail_gun_post_request
    if mail_gun_message_hash = MailgunMessage.process_mailgun(params)
      e = EmailDataProcessor.new(mail_gun_message_hash)
      e.process_single_email
    end
    render json: { status: 200, message: "cheers!" }
  end
end
