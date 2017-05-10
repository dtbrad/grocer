require 'google/apis/gmail_v1'
class Scraper

  def self.process_emails(user, date, token, orig_email)
    client = Signet::OAuth2::Client.new(access_token: token)
    client.expires_in = Time.now + 1_000_000
    service = Google::Apis::GmailV1::GmailService.new
    service.authorization = client
    email_ids = grab_email_ids(user, date, service, orig_email)
    emails = get_full_emails(user, email_ids, service)
    if emails.length > 0
      emails.each do |email|
            basket = user.baskets.build(date: email[:date])
        rows = get_the_right_rows(email[:body])
        rows.length.times do |i|
          info = get_data(rows, i)
          build_products_and_line_items(basket, info, user)
        end
        basket.total_cents = basket.line_items.total_spent
        basket.save
      end
    end
  end

  def self.grab_email_ids(user, date, service, orig_email)
    account_email = service.get_user_profile('me').email_address
    if orig_email.empty?
      q = "'Your New Seasons Market Email Receipt' from: receipts@newseasonsmarket.com after:#{date} to:#{account_email}"
    else
      q = "'Your New Seasons Market Email Receipt' after:#{date} {to:#{orig_email} to:#{account_email}}"
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
        subject = email.payload.headers.find {|h| h.name == "Subject" }.value
        if subject == "Your New Seasons Market Email Receipt"
          mes = prepare_original(user, email, email_array)
        else
          mes = prepare_forwarded(user, email, email_array)
        end
        email_array.push(mes) unless (!mes || user.baskets.find_by(user: user, date: mes[:date])|| email_array.any?{|email| email[:date] == mes[:date]})
      end
    end
    email_array
  end

  def self.prepare_original(user, email, email_array)
    email_date = ActiveSupport::TimeZone["America/Los_Angeles"].parse(email.payload.headers.find {|h| h.name == "Date" }.value).change(:sec => 0)
    body = email.payload.body.data unless user.baskets.find_by(user: user, date: email_date)
    my_email = {
      date: email_date,
      body: body
    }
  end

  def self.prepare_forwarded(user, email, email_array)
    header = email.payload.headers.find {|h| h.name == "From" }.value

    if email.payload.headers.find {|h| h.name == "From" }.value.include?("gmail.com")
      email_date = ActiveSupport::TimeZone["America/Los_Angeles"].parse(email.payload.parts.last.body.data[/(Sun|Mon|Tue|Wed|Thu|Fri|Sat), (Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) [0-9]{1,2}, [0-9]{1,4} at [0-9]{1,2}:[0-9]{1,2} (A|P)M/])
    elsif email.payload.headers.find {|h| h.name == "From" }.value.include?("google.com")
      email_date = ActiveSupport::TimeZone["America/Los_Angeles"].parse(email.payload.headers.find {|h| h.name == "Received" }.value[/(Sun|Mon|Tue|Wed|Thu|Fri|Sat), [0-9]{1,2} (Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) [0-9]{1,4} [0-9]{1,2}:[0-9]{1,2}/])
    elsif email.payload.headers[6].value.include?("yahoo.com")
      email_date = ActiveSupport::TimeZone["America/Los_Angeles"].parse(email.payload.parts.last.body.data[/(Sunday|Mon|Tue|Wed|Thu|Fri|Sat), (Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) [0-9]{1,2}, [0-9]{1,4} [0-9]{1,2}:[0-9]{1,2} (A|P)M/])
    else
    end
    if email_date
      body = email.payload.parts.last.body.data unless user.baskets.find_by(user: user, date: email_date)
      my_email = {
        date: email_date,
        body: body
      }
    end
  end

  def self.get_the_right_rows(body)
    noko_body = Nokogiri::HTML(body)
    noko_body.xpath(
      '//tr[td[contains(@class, "basket-item-desc modifier") or contains(@class, "basket-item-desc") ]
       and td[contains(@class, "basket-item-qty modifier") or contains(@class, "basket-item-qty") ]
       and td[contains(@class, "basket-item-amt modifier") or contains(@class, "basket-item-amt") ] or td[span]]'
    )
  end

  def self.get_data(rows, i)
    unless rows[i].css('span').text.include?('$') || rows[i].text.include?('Discount') || rows[i].text.include?("Transaction Date")
      info = { name: rows[i].css('td[class*="basket-item-desc"]').text.strip,
               total_cents: (rows[i].css('td[class*="basket-item-amt"]').text.to_d * 100).to_i
             }
      unit_pricing = rows[i + 1] && rows[i + 1].css('span').text.include?('$')
      has_weight_unit = rows[i + 1] && rows[i + 1].text.include?('@')
      has_discount = rows[i + 1] && rows[i + 1].text.include?('Discount')

      if !unit_pricing
        info[:quantity] = rows[i].css('td[class*="basket-item-qty"]').text.to_i
        info[:quantity] = 1 unless info[:quantity].nonzero?

      elsif unit_pricing && !has_weight_unit
        info[:price_cents] = (rows[i + 1].text[/\$\s*(\d+\.\d+)/, 1].to_d * 100).to_i
        info[:quantity] = rows[i].css('td[class*="basket-item-qty"]').text.to_i

      elsif unit_pricing && has_weight_unit
        info[:price_cents] = rows[i + 1].text[/\$\s*(\d+\.\d+)/, 1].to_d. * 100
        info[:quantity] = rows[i].css('td[class*="basket-item-qty"]').text.to_i
        info[:weight] = rows[i + 1].text[/([\d.]+)\s/].to_d
      end

      if has_discount
        info[:disc] = (rows[i + 1].text[/\d+[,.]\d+/].to_d * -100).to_i
        info[:total_cents] += info[:disc]
      else
        info[:disc] = 0
      end
      info
    end
  end

  def self.build_products_and_line_items(basket, info, user)
    unless info.nil?
      product = Product.find_or_create_by(name: info[:name].titleize)
      if info[:price_cents] != nil
        price = info[:price_cents]
        weight = info[:weight]
      elsif info[:price_cents] == nil && product.real_unit_price_cents
        price = product.real_unit_price_cents.to_d
        weight = (info[:total_cents].to_d / price).round(2)
      else
        price = info[:total_cents]
        weight = info[:weight]
      end
      basket.line_items.build(
        user: user,
        product: product,
        price_cents: price,
        quantity: info[:quantity],
        weight: weight,
        total_cents: info[:total_cents],
        discount_cents: info[:disc]
      )
      basket.save
    end
  end
end
