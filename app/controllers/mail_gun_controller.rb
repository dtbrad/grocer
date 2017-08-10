class MailGunController < ApplicationController
  skip_before_action :verify_authenticity_token

  def process_mail_gun_post_request
    Scraper.process_mailgun(params)
    render json: { status: 200 }
  end
end
