class MailgunWorker
  include Sidekiq::Worker
  include MessageHelper

  def perform(id)
    mailgun_object = MailgunObject.find(id)
    shopper = User.from_mailgun(mailgun_object.recipient)
    return unless mailgun_message = shopper.mailgun_messages.find_or_create_by(date: mailgun_object.transaction_date) do |mm|
      mm.body_field = mailgun_object.body_field
      mm.x_envelope_from_field = mailgun_object.x_envelope_from_field
      mm.to_field = mailgun_object.to_field
      mm.from_field = mailgun_object.from_field
    end
    EmailDataProcessor.new(mailgun_message).process_single_email
    mailgun_object.destroy
  end
end
