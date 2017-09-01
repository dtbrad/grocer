class EmailParser

  attr_accessor :body, :rows

  def initialize(body)
    @body = body
  end

  def parse_email
    if new_format_manually_forwarded
      rows = Nokogiri::HTML(body).css('.basket-body tr')
      parse_method = 'parse_new_format'
    elsif new_format_auto_forwarded
      rows = pick_rows_alternate
      parse_method = 'parse_new_format'
    else # older email format
      rows = pick_rows
      parse_method = 'parse_old_format'
    end
    info_array = []
    rows.length.times do |i|
      info = eval("#{parse_method}(rows, i)")
      info_array << info
    end
    info_array
  end

  def new_format_manually_forwarded
    !Nokogiri::HTML(body).css('.empty-row').empty?
  end

  def new_format_auto_forwarded
    Nokogiri::HTML(body).css('td[class*="basket-item-desc"]').empty?
  end

  def pick_rows
    noko_body = Nokogiri::HTML(body)
    noko_body.xpath(
      '//tr[td[contains(@class, "basket-item-desc modifier") or contains(@class, "basket-item-desc") ]
       and td[contains(@class, "basket-item-qty modifier") or contains(@class, "basket-item-qty") ]
       and td[contains(@class, "basket-item-amt modifier") or contains(@class, "basket-item-amt") ] or td[span]]'
    )
  end

  def pick_rows_alternate
    noko_body = Nokogiri::HTML(body)
    noko_body.xpath(
      '//tr[td[contains(@class, "item-description")]
       and td[contains(@class, "item-amount")]
       and td[contains(@class, "item-qty")] or td[span]]'
    )
  end

  def parse_old_format(rows, i)
    return if rows[i].css('span').text.include?('$') || ['Discount', 'Transaction Date', 'Terms & Conditions | Privacy', 'Unsubscribe | Change email address | Not your receipt?'].include?(rows[i].text)
    name_value = rows[i].css('td[class*="basket-item-desc"]').text.strip
    name = name_value.empty? ? "blank item" : name_value
    info = { name: name,
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

  def parse_new_format(rows, i)
    return if rows[i].css('span').text.include?('$') || rows[i].text.include?('Discount') || rows[i].text.include?('Transaction Date') || ( !rows[i].attributes.empty? && rows[i].attributes["class"].value == "empty-row" )
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

    info[:total_cents] = -info[:total_cents] if credit_promotion && info[:total_cents] >= 0

    if has_discount
      info[:disc] = (rows[i + 2].text[/\d+[,.]\d+/].to_d * -100).to_i
      info[:total_cents] += info[:disc]
    else
      info[:disc] = 0
    end
    info
  end

end
