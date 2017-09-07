class EmailParser
  attr_accessor :item_rows

  def initialize(body)
    rows = Nokogiri::HTML(body).search('//text()').map(&:text).delete_if { |x| x !~ /\w/ }.collect(&:squish)
    items_beg = rows.find_index { |i| %w[Price Cost].include?(i) }
    items_end = rows.find_index { |i| ["SUB TOTAL", "Subtotal"].include?(i) }
    @item_rows = rows[(items_beg + 1)..(items_end - 1)]
  end

  def parse_email
    item_rows.collect.with_index { |_row, i| item_info(i) }.compact
  end

  def item_info(i)
    return unless credit_promotion_name(i) || item_name(i)
    { name: credit_promotion_name(i) || item_name(i), total_cents: credit_promotion_amount(i) || total_price(i),
      qty: qty(i), unit_price: unit_price(i), weight: weight(i), price_per_pound: price_per_pound(i) }
  end

  def integer_string?(i)
    item_rows[i] && item_rows[i][/(^\d+$)|(^\.$)/]
  end

  def float_string?(i)
    item_rows[i] && item_rows[i][/^[-+]?[$]?[0-9]+\.[0-9]+$/]
  end

  def credit_promotion_name(i)
    item_rows[i] if float_string?(i + 1) && !integer_string?(i - 1)
  end

  def credit_promotion_amount(i)
    return unless credit_promotion_name(i)
    amt = (item_rows[i + 1].delete("$").to_d * 100).to_i
    amt <= 0 ? amt : -amt
  end

  def item_name(i)
    item_rows[i + 1] if integer_string?(i) && float_string?(i + 2)
  end

  def total_price(i)
    (item_rows[i + 2].delete("$").to_d * 100).to_i if float_string?(i + 2)
  end

  def qty(i)
    item_rows[i][/^[0-9]$/].to_i
  end

  def weight(i)
    row = item_rows[i + 3]
    row.split(%r{@|\/|\$})[0].to_d if row && ["$", "@"].all? { |char| row.include?(char) }
  end

  def price_per_pound(i)
    return unless weight(i)
    row = item_rows[i + 3]
    (row.split(%r{@|\/|\$})[2].to_d * 100).to_i if row && ["$", "@"].all? { |char| row.include?(char) }
  end

  def unit_price(i)
    return if weight(i)
    row = item_rows[i + 3]
    (row.split(/\s|\$/)[1].to_d * 100).to_i if row && ["$", "each"].all? { |char| row.include?(char) }
  end
end
