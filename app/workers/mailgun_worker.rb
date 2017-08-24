class MailgunWorker
  include Sidekiq::Worker

  def perform(params)
    params_json = JSON.parse(params)
    return unless mail_gun_message_hash = MailgunMessage.process_mailgun(params_json)
    e = EmailDataProcessor.new(mail_gun_message_hash)
    e.process_single_email
  end
end
