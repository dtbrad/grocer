class FakeMailgun
  def self.post_mailgun(url)
    dam = 'api'
    api_key = ENV['mailgun_api_key']
    response = RestClient::Request.execute method: :get, url: url, user: dam, password: api_key
    object = JSON.parse(response.body)

    mailgun_object = MailgunObject.create(data: object)
    MailgunWorker.perform_async(mailgun_object.id)

    # if mailgun_package = MailgunMessage.process_new_mailgun(object)
    #   EmailDataProcessor.new(mailgun_package).process_single_email
    # end

  end
end
