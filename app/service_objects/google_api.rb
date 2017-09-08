class GoogleApi
  attr_accessor :service

  def initialize(token)
    client = Signet::OAuth2::Client.new(access_token: token)
    client.expires_in = Time.now + 1_000_000
    @service = Google::Apis::GmailV1::GmailService.new
    @service.authorization = client
  end

  def self.process_api_request(user, token)
    gmail = GoogleApi.new(token)
    email_ids = gmail.grab_email_ids
    return if email_ids.messages.nil?
    email_ids.messages.each do |email_id|
      raw_gmail_object = gmail.get_full_email(user, email_id.id)
      if gmail_package = GoogleMailObject.process_new_gmail(raw_gmail_object)
        EmailDataProcessor.new(gmail_package).process_single_email
      end
    end
  end

  def grab_email_ids
    q = "subject:'Your New Seasons Market Email Receipt' {from: receipts@newseasonsmarket.com from: noreply@index.com}"
    service.list_user_messages(
      'me',
      include_spam_trash: nil,
      max_results: 3000,
      q: q
    )
  end

  def get_full_email(user, email_id)
    email = service.get_user_message('me', email_id)
    return unless email
    email_json = email.to_json
    parsed_json = JSON.parse(email_json)
    encoded_body_field = parsed_json["payload"]["body"]["data"] || parsed_json["payload"]["parts"][0]["body"]["data"]
    body_field = Base64.urlsafe_decode64(encoded_body_field)
    { user: user, body_field: body_field, data: parsed_json }
  end
end
