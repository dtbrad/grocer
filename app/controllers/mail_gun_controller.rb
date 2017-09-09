class MailGunController < ApplicationController
  skip_before_action :verify_authenticity_token

  def process_mail_gun_post_request
    MailgunWorker.perform_async(params["body-html"],
                                params["To"],
                                params["From"],
                                params["X-Envelope-From"],
                                params)
    render json: { status: 200, message: "cheers!" }
  end

  def process_forward_request
    return unless MailgunMessage.give_google_forwarding_permission(params["body-plain"])
    AutoforwardMailer.autoforward_mailer(params["Subject"]).deliver
    render json: { status: 200, message: "cheers!" }
  end
end
