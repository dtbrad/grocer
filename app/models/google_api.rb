class GoogleApi
  def self.retrieve_emails(user, date, token, orig_email)
    service = self.service(token)
    email_ids = grab_email_ids(user, date, service, orig_email)
    emails = get_full_emails(user, email_ids, service)
  end

  def self.service(token)
    client = Signet::OAuth2::Client.new(access_token: token)
    client.expires_in = Time.now + 1_000_000
    service = Google::Apis::GmailV1::GmailService.new
    service.authorization = client
    service
  end

  def self.grab_email_ids(_user, date, service, orig_email)
    account_email = service.get_user_profile('me').email_address
    if orig_email.empty?
      q = "subject:'Your New Seasons Market Email Receipt' {from: receipts@newseasonsmarket.com from: noreply@index.com} after:#{date} to:#{account_email}"
    else
      q = "subject:'Your New Seasons Market Email Receipt' after:#{date} {to:#{orig_email} to:#{account_email}}"
    end
    @emails = service.list_user_messages(
      'me',
      include_spam_trash: nil,
      max_results: 1000,
      q: q
    )
  end

  def self.get_full_emails(user, email_ids, service)
    email_array = []
    if set = email_ids.messages
      set.each do |i|
        email = service.get_user_message('me', i.id)
        subject = email.payload.headers.find { |h| h.name == 'Subject' }.value
        mes = if subject == 'Your New Seasons Market Email Receipt'
                prepare_original(user, email, email_array)
              else
                prepare_forwarded(user, email, email_array)
              end
        email_array.push(mes) unless !mes || user.baskets.find_by(user: user, date: mes[:date]) || email_array.any? { |email| email[:date] == mes[:date] }
      end
    end
    email_array
  end

  def self.prepare_original(user, email, _email_array)
    email_date = DateTime.parse(email.payload.headers.find { |h| h.name == 'Date' }.value).change(sec: 0)  - 7.hours
    body = email.payload.body.data unless user.baskets.find_by(user: user, date: email_date)
    my_email = {
      date: email_date,
      body: body
    }
  end

  def self.prepare_forwarded(user, email, _email_array)
    if email.payload.headers.find { |h| h.name == 'From' }.value.include?('gmail.com')
      email_date = DateTime.parse(email.payload.parts.last.body.data[/(Sun|Mon|Tue|Wed|Thu|Fri|Sat), (Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) [0-9]{1,2}, [0-9]{1,4} at [0-9]{1,2}:[0-9]{1,2} (A|P)M/])
      body = email.payload.parts.last.body.data unless user.baskets.find_by(user: user, date: email_date)
    end
    if email_date
      body = email.payload.parts.last.body.data unless user.baskets.find_by(user: user, date: email_date)
      my_email = {
        date: email_date,
        body: body
      }
      my_email
    end
  end
end
