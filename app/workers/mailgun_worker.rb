class MailgunWorker
  include Sidekiq::Worker

  def perform(body_html, to_field, from_field, x_envelope_from_field, params)
    mailgun_object = { body_field: body_html,
                       to_field: to_field,
                       from_field: from_field,
                       x_envelope_from_field: x_envelope_from_field,
                       data: params }
    return unless mailgun_package = MailgunMessage.process_new_mailgun(mailgun_object)
    EmailDataProcessor.new(mailgun_package).process_single_email
  end
end
