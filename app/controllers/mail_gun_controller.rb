class MailGunController < ApplicationController
  skip_before_action :verify_authenticity_token

  def process_mail_gun_post_request
    mailgun_object = MailgunObject.create(data: bare_params)
    MailgunWorker.perform_async(mailgun_object.id)
    render json: { status: 200, message: "cheers!" }
  end

  def process_forward_request
    return unless MailgunMessage.give_google_forwarding_permission(params["body-plain"])
    AutoforwardMailer.autoforward_mailer(params["Subject"]).deliver
    render json: { status: 200, message: "cheers!" }
  end

  private

  def bare_params
    params.except("attachment-1")
  end
end
