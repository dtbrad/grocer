class Scraper
  def self.process_mailgun(params)
    body = params["body-html"]
    if params["Delivered-To"] # forwarded via gmail filter
      email = params["Delivered-To"]
      email_date = DateTime.parse(params["Date"]).change(sec: 0) - 7.hours
    else  # forwarded manually from gmail
      email = params["X-Envelope-From"].delete('<>')
      if email_string = body[/(Sun|Mon|Tue|Wed|Thu|Fri|Sat), (Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) [0-9]{1,2}, [0-9]{1,4} at [0-9]{1,2}:[0-9]{1,2} (A|P)M/]
        email_date = DateTime.parse(email_string).change(sec: 0)
      elsif email_string = body[/(Sunday|Monday|Tuesday|Wednesday|Thursday|Friday|Saturday), (Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) [0-9]{1,2}, [0-9]{1,4} [0-9]{1,2}:[0-9]{1,2} (A|P)M/]
        email_date = DateTime.parse(email_string).change(sec: 0)
      elsif email_string = body[/(January|February|March|April|May|June|July|August|September|October|November|December) [0-9]{1,2}, \d{4} at [0-9]{1,2}:[0-9]{1,2}:[0-9]{1,2} (A|P)M/]
        email_date = DateTime.parse(email_string).change(sec: 0)
      end
    end
    user = if User.find_by(email: email)
             User.find_by(email: email)
           else
             User.create(email: email, name: params["From"].split(" <")[0], password: Devise.friendly_token.first(6), generated_from_email: true)
           end
    return if user.baskets.where(date: email_date).count > 0
    basket = user.baskets.build(date: email_date)
    if !Nokogiri::HTML(body).css('.savings-label').empty?
      rows = Nokogiri::HTML(body).css('.basket-body tr')
      rows.length.times do |i|
        info = parse_new_style(rows, i)
        build_products_and_line_items(basket, info, user)
      end
    elsif Nokogiri::HTML(body).css('td[class*="basket-item-desc"]').empty?
      rows = get_the_right_rows_new_forwarded(body)
      rows.length.times do |i|
        info = parse_new_style(rows, i)
        build_products_and_line_items(basket, info, user)
      end
    else
      rows = get_the_right_rows(body)
      rows.length.times do |i|
        info = parse_old_style(rows, i)
        build_products_and_line_items(basket, info, user)
      end
    end
    basket.total_cents = basket.line_items.collect(&:total_cents).inject { |sum, n| sum + n }
    basket.save
  end

  def self.process_emails(user, date, token, orig_email)
    emails = GoogleApi.retrieve_emails(user, date, token, orig_email)
    unless emails.empty?
      emails.each do |email|
            basket = user.baskets.build(date: email[:date])
        process_single_email(basket, email[:body], user)
      end
    end
  end

  def self.process_single_email(basket, body, user)
    if !Nokogiri::HTML(body).css('.savings-label').empty? # newer email format original or auto-forwarded
      rows = Nokogiri::HTML(body).css('.basket-body tr')
      parse_method = 'parse_new_style'
    elsif Nokogiri::HTML(body).css('td[class*="basket-item-desc"]').empty? # newer email format manually forwarded
      rows = get_the_right_rows_new_forwarded(body)
      parse_method = 'parse_new_style'
    else # older email format (original or forwarded)
      rows = get_the_right_rows(body)
      parse_method = 'parse_old_style'
    end
    rows.length.times do |i|
      info = eval("#{parse_method}(rows, i)")
      build_products_and_line_items(basket, info, user)
    end
    basket.total_cents = basket.line_items.collect(&:total_cents).inject { |sum, n| sum + n }
    basket.save
  end

  def self.get_the_right_rows(body)
    noko_body = Nokogiri::HTML(body)
    noko_body.xpath(
      '//tr[td[contains(@class, "basket-item-desc modifier") or contains(@class, "basket-item-desc") ]
       and td[contains(@class, "basket-item-qty modifier") or contains(@class, "basket-item-qty") ]
       and td[contains(@class, "basket-item-amt modifier") or contains(@class, "basket-item-amt") ] or td[span]]'
    )
  end

  def self.get_the_right_rows_new_forwarded(body)
    noko_body = Nokogiri::HTML(body)
    noko_body.xpath(
      '//tr[td[contains(@class, "item-description")]
       and td[contains(@class, "item-amount")]
       and td[contains(@class, "item-qty")] or td[span]]'
    )
  end

  def self.parse_old_style(rows, i)
    unless rows[i].css('span').text.include?('$') || ['Discount', 'Transaction Date', 'Terms & Conditions | Privacy', 'Unsubscribe | Change email address | Not your receipt?'].include?(rows[i].text)
      info = { name: rows[i].css('td[class*="basket-item-desc"]').text.strip,
               total_cents: (rows[i].css('td[class*="basket-item-amt"]').text.to_d * 100).to_i }
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
        info[:price_cents] = (rows[i + 1].text[/\$\s*(\d+\.\d+)/, 1].to_d. * 100).to_i
        info[:quantity] = 1
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

  def self.parse_new_style(rows, i)
    unless rows[i].css('span').text.include?('$') || rows[i].text.include?('Discount') || rows[i].text.include?('Transaction Date') || ( !rows[i].attributes.empty? && rows[i].attributes["class"].value == "empty-row" )
      info = { name: rows[i].css('td[class*="item-description"]').text.strip,
               total_cents: (rows[i].css('td[class*="item-amount"]').text.strip.tr('$', '').to_d * 100).to_i }
      unit_pricing = rows[i + 1] && rows[i + 1].css('span').text.include?('$')
      has_weight_unit = rows[i + 1] && rows[i + 1].text.include?('@')
      has_discount = rows[i + 1] && rows[i + 1].text.include?('Discount')
      credit_promotion = !rows[i].attributes['class'].nil? && rows[i].attributes['class'].value.include?('basket-discount-item')

      if !unit_pricing
        info[:quantity] = rows[i].css('td[class*="item-qty"]').text.to_i
        info[:quantity] = 1 unless info[:quantity].nonzero?

      elsif unit_pricing && !has_weight_unit
        info[:price_cents] = (rows[i + 1].text[/\$\s*(\d+\.\d+)/, 1].to_d * 100).to_i
        info[:quantity] = rows[i].css('td[class*="item-qty"]').text.to_i

      elsif unit_pricing && has_weight_unit
        info[:price_cents] = (rows[i + 1].text[/\$\s*(\d+\.\d+)/, 1].to_d. * 100).to_i
        info[:quantity] = 1
        info[:weight] = rows[i + 1].css('span').text.strip.split('@')[0].to_d
      end

      info[:total_cents] = -info[:total_cents] if credit_promotion

      if has_discount
            info[:disc] = (rows[i + 2].text[/\d+[,.]\d+/].to_d * -100).to_i
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
      if !info[:price_cents].nil?
        price = info[:price_cents]
        weight = info[:weight]
      elsif info[:price_cents].nil? && product.real_unit_price_cents
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
    end
  end
end
