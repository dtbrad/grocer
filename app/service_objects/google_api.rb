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
    return unless email_ids = gmail.grab_email_ids(user).messages
    email_ids.each do |email_id|
      gmail_object = gmail.get_full_email(email_id.id)
      gmail_object.make_shopping_data
    end
  end

  def grab_email_ids(user)
    q = "subject:'Your New Seasons Market Email Receipt' {from: receipts@newseasonsmarket.com from: noreply@index.com} to:#{user.email}"
    service.list_user_messages(
      'me',
      include_spam_trash: nil,
      max_results: 3000,
      q: q
    )
  end

  def get_full_email(email_id)
    email = service.get_user_message('me', email_id)
    email_json = email.to_json
    GoogleMailObject.create(data: email_json)
  end
end
