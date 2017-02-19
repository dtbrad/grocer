class Scraper
  def self.process_emails(user, date)
    emails = grab_emails(user, date)
    emails.each do |email|
      next if Basket.find_by(user: user, date: email.date)
      basket = user.baskets.build(date: DateTime.parse(email.date))
      rows = get_the_right_rows(email)
      rows.length.times do |i|
        info = get_data(rows, i)
        build_products_and_line_items(basket, info, user)
      end
      basket.save
      basket.total_cents = basket.line_items.total_spent
      basket.save
    end
  end

  def self.grab_emails(user, date)
    gmail = Gmail.connect(:xoauth2, user.email, user.oauth_token)
    gmail.inbox.emails(
      from: 'receipts@newseasonsmarket.com',
      after: Date.parse(date)
    )
  end

  def self.get_the_right_rows(email)
    body = Nokogiri::HTML(email.body.decoded)
    body.xpath(
      '//tr[(td[(@class = "basket-item-qty") and normalize-space()]
      and td[(@class = "basket-item-desc") and normalize-space()]
      and td[(@class = "basket-item-amt") and normalize-space()]) or td[span]]'
    )
  end

  def self.get_data(rows, i)
    unless rows[i].css('span').text.include?('$')

      info = { name: rows[i].css('.basket-item-desc').text.strip }
      unit_pricing = rows[i + 1] && rows[i + 1].css('span').text.include?('$')
      has_weight_unit = rows[i + 1] && rows[i + 1].text.include?('@')

      if !unit_pricing
        info[:price_cents] = rows[i].css('.basket-item-amt').text.to_f * 100
        info[:quantity] = rows[i].css('.basket-item-qty').text.to_i
        info[:quantity] = 1 unless info[:quantity].nonzero?
        info[:total_cents] = info[:quantity] * info[:price_cents]

      elsif unit_pricing && !has_weight_unit
        info[:price_cents] = rows[i + 1].text[/\$\s*(\d+\.\d+)/, 1].to_f * 100
        info[:quantity] = rows[i].css('.basket-item-qty').text.to_i
        info[:total_cents] = info[:quantity] * info[:price_cents]

      elsif unit_pricing && has_weight_unit
        info[:price_cents] = rows[i + 1].text[/\$\s*(\d+\.\d+)/, 1].to_f. * 100
        info[:quantity] = rows[i].css('.basket-item-qty').text.to_i
        info[:weight] = rows[i + 1].text[/([\d.]+)\s/].to_f
        info[:total_cents] = (info[:weight] * info[:price_cents]).ceil

      end
      info
    end
  end

  def self.build_products_and_line_items(basket, info, user)
    unless info.nil?
      product = Product.find_or_create_by(name: info[:name].titleize,
                                          nickname: info[:name].titleize)
      basket.line_items.build(
        user: user,
        product: product,
        price_cents: info[:price_cents],
        quantity: info[:quantity],
        weight: info[:weight],
        total_cents: info[:total_cents]
      )
    end
  end
end
