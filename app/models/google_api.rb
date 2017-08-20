class GoogleApi

  attr_accessor :service

  def initialize(token)
    client = Signet::OAuth2::Client.new(access_token: token)
    client.expires_in = Time.now + 1_000_000
    @service = Google::Apis::GmailV1::GmailService.new
    @service.authorization = client
  end

  def grab_email_ids(user, date)
    q = "subject:'Your New Seasons Market Email Receipt' {from: receipts@newseasonsmarket.com from: noreply@index.com} after:#{date} to:#{user.email}"
    emails = service.list_user_messages(
      'me',
      include_spam_trash: nil,
      max_results: 1000,
      q: q
    )
  end

  def get_full_email(email_id, user)
    email = service.get_user_message('me', email_id)
    email_json = email.to_json
    j = JSON.parse(email_json) # don't understand why, but need to use both google's and rails' json methods to make work
    email_date = DateTime.parse(j["payload"]["headers"].find{|h| h["name"] == 'Date' }["value"]).change(sec: 0)  - 7.hours
    GoogleMailObject.create(user: user, data: email_json, date: email_date)
  end
end
