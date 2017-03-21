require 'google/apis/gmail_v1'
class Scraper

  def self.process_emails(user, date, token)
    emails = grab_emails(user, date, token)
    if emails.length > 0
      emails.each do |email|
        basket = user.baskets.build(date: email[:date])
        rows = get_the_right_rows(email[:body])
        rows.length.times do |i|
          info = get_data(rows, i)
          build_products_and_line_items(basket, info, user)
        end
        basket.save
        basket.total_cents = basket.line_items.total_spent
        basket.save
      end
    end
  end

  def self.grab_emails(user, date, token)
    client = Signet::OAuth2::Client.new(access_token: token)
    client.expires_in = Time.now + 1_000_000
    service = Google::Apis::GmailV1::GmailService.new
    service.authorization = client
    @emails = service.list_user_messages(
      'me',
      include_spam_trash: nil,
      max_results: 1000,
      q: "from: receipts@newseasonsmarket.com after: #{date}",
    )
    email_array = []
    if set = @emails.messages
      set.each do |i|
        email = service.get_user_message('me', i.id)
        my_email = {
          date: email.payload.headers.find {|h| h.name == "Date" }.value,
          body: email.payload.body.data
        }
        email_array.push(my_email) unless user.baskets.find_by(user: user, date: my_email[:date])
      end
    end
    email_array
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
    unless (rows[i].css('span').text.include?('$') || rows[i].text.include?('Discount'))
      info = { name: rows[i].css('.basket-item-desc').text.strip }
      unit_pricing = rows[i + 1] && rows[i + 1].css('span').text.include?('$')
      has_weight_unit = rows[i + 1] && rows[i + 1].text.include?('@')
      has_discount = rows[i + 1] && rows[i + 1].text.include?('Discount')

      if !unit_pricing
        info[:quantity] = rows[i].css('.basket-item-qty').text.to_i
        info[:quantity] = 1 unless info[:quantity].nonzero?
        info[:total_cents] = rows[i].css('.basket-item-amt').text.to_f * 100

      elsif unit_pricing && !has_weight_unit
        info[:price_cents] = rows[i + 1].text[/\$\s*(\d+\.\d+)/, 1].to_f * 100
        info[:quantity] = rows[i].css('.basket-item-qty').text.to_i
        info[:total_cents] = info[:quantity] * info[:price_cents]

      elsif unit_pricing && has_weight_unit
        info[:price_cents] = rows[i + 1].text[/\$\s*(\d+\.\d+)/, 1].to_f. * 100
        info[:quantity] = rows[i].css('.basket-item-qty').text.to_i
        info[:weight] = rows[i + 1].text[/([\d.]+)\s/].to_f
        info[:total_cents] = (info[:weight] * info[:price_cents]).round
      end
      if has_discount
        info[:disc] = rows[i + 1].text[/\d+[,.]\d+/].to_f * -100
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
      li = basket.line_items.build(
        user: user,
        product: product,
        price_cents: info[:price_cents],
        quantity: info[:quantity],
        weight: info[:weight],
        total_cents: info[:total_cents],
        discount_cents: info[:disc]
      )
      if li.product.real_unit_price_cents && !li.price_cents
        li.price_cents = li.product.real_unit_price_cents
        li.weight = (li.total_cents.to_f / li.price_cents.to_f).round(2)
      elsif !li.product.real_unit_price_cents && !li.price_cents
        li.price_cents = li.total_cents
      end
    end
  end
end
