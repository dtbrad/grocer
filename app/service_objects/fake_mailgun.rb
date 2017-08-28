class FakeMailgun
  def self.post_mailgun(url)
    user = 'api'
    api_key = ENV['mailgun_api_key']
    response = RestClient::Request.execute method: :get, url: url, user: user, password: api_key
    object = JSON.parse(response.body)
    mail_gun_message = MailgunMessage.process_mailgun(object)
    e = EmailDataProcessor.new(mail_gun_message)
    e.process_single_email
  end
end
