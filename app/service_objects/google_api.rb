class GoogleApi
  attr_accessor :service, :token

  def initialize(token)
    client = Signet::OAuth2::Client.new(access_token: token)
    client.expires_in = Time.now + 1_000_000
    @service = Google::Apis::GmailV1::GmailService.new
    @service.authorization = client
    @token = token
  end

  def self.process_api_request(user, token)
    gmail = GoogleApi.new(token)
    email_ids = gmail.grab_email_ids(gmail)
    return if email_ids.nil?
    email_ids.each do |email_id|
      raw_gmail_object = gmail.get_full_email(user, email_id.id)
      if gmail_object = GoogleMailObject.process_new_gmail(raw_gmail_object)
        EmailDataProcessor.new(gmail_object).process_single_email
      end
    end
  end

  def grab_email_ids(gmail)
    email_ids = []
    next_page_token = nil
    loop do
      results = retrieve(gmail, next_page_token)
      next if results.messages.empty?
      results.messages.each { |m| email_ids << m }
      next_page_token = results.next_page_token
      break if next_page_token.nil?
    end
    email_ids
  end

  def retrieve(gmail, next_page_token)
    q = "subject:'Your New Seasons Market Email Receipt' {from: #{Rails.application.config.receipt_email} from: #{Rails.application.config.receipt_email_2}}"
    gmail.service.list_user_messages(
      'me',
      include_spam_trash: nil,
      max_results: 3000,
      q: q,
      page_token: next_page_token
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
