class EmailParser
  attr_accessor :rows

  def initialize(body)
    @rows = EmailParser.extract_text_rows(body)
  end

  def self.extract_text_rows(body)
    Nokogiri::HTML(body).search('//text()').map(&:text).delete_if { |x| x !~ /\w/ }.collect(&:squish)
  end

  def self.cc_field(body)
    rows = extract_text_rows(body)
    loc = rows.find_index { |i| i [/^(Total|TOTAL)$/] }
    rows[loc + 2]
  end

  def self.extract_email(value)
    value.scan(/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i).first
  end

  def self.extract_urls(value)
    value.scan(/https:+\/\/\S+/)
  end

  def self.transaction_date(body)
    rows = extract_text_rows(body)
    loc = rows.find_index { |i| i == "Transaction Date" }
    rows[loc + 1]
  end

  def item_rows
    items_beg = rows.find_index { |i| %w[Price Cost].include?(i) }
    items_end = rows.find_index { |i| ["SUB TOTAL", "Subtotal"].include?(i) }
    rows[(items_beg + 1)..(items_end - 1)]
  end

  def parse_email # return array of item info objects using #item_info method
    item_rows.collect.with_index { |_row, i| item_info(i) }.compact
  end

  def item_info(i) # process range of rows in vicinity of i row to produce item info object using lots of helper methods
     return unless credit_promotion_name(i) || item_name(i)
    { name: credit_promotion_name(i) || item_name(i), total_cents: credit_promotion_amount(i) || total_price(i),
      qty: qty(i), unit_price: unit_price(i), weight: weight(i), price_per_pound: price_per_pound(i) }
  end

  def integer_string?(i) # does an element with this index exist and is it an "integer" string? ex: ("5")
    item_rows[i] && item_rows[i][/(^\d+$)|(^\.$)/]
  end

  def float_string?(i) # does an element with this index exist and is it a "float" string? ex: ("5.00" or "$5.00")
    item_rows[i] && item_rows[i][/^[-+]?[$]?[0-9]+\.[0-9]+$/]
  end

  def credit_promotion_name(i) # returns credit promotion name from i's row if adjacent rows meet conditions
    item_rows[i] if float_string?(i + 1) && !integer_string?(i - 1)
  end

  def credit_promotion_amount(i) # returns credit promotion amt from i + 1 row if credit promotion helper returns truthy
    return unless credit_promotion_name(i)
    amt = (item_rows[i + 1].delete("$").to_d * 100).to_i
    amt <= 0 ? amt : -amt
  end

  def item_name(i) # returns item name from i + 1 row if referenced rows meet conditions
    item_rows[i + 1] if integer_string?(i) && float_string?(i + 2)
  end

  def total_price(i) # returns total price from i + 2 row if referenced row meets condition
    (item_rows[i + 2].delete("$").to_d * 100).to_i if float_string?(i + 2)
  end

  def qty(i)
    item_rows[i][/^[0-9]$/].to_i
  end

  def weight(i) # returns weight if i + 3 row exists and contains "$" and "@"
    row = item_rows[i + 3]
    row.split(%r{@|\/|\$})[0].to_d if row && ["$", "@"].all? { |char| row.include?(char) }
  end

  def price_per_pound(i) # returns price per pound if i + 3 row exists and contains "$" and "@"
    return unless weight(i)
    row = item_rows[i + 3]
    (row.split(%r{@|\/|\$})[2].to_d * 100).to_i if row && ["$", "@"].all? { |char| row.include?(char) }
  end

  def unit_price(i) # returns unit price if i + 3 row exists and contains "$" and "each"
    return if weight(i)
    row = item_rows[i + 3]
    (row.split(/\s|\$/)[1].to_d * 100).to_i if row && ["$", "each"].all? { |char| row.include?(char) }
  end
end
