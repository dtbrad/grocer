class MailGunController < ApplicationController
  skip_before_action :verify_authenticity_token

  def process_mail_gun_post_request
    MailgunWorker.perform_async(params.to_json)
    render json: { status: 200, message: "cheers!" }
  end
end
