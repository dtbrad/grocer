class EmailDataProcessor
  attr_accessor :email

  def initialize(message)
    @date = message[:date]
    @body = message[:body]
    @user = message[:user]
  end

  def process_single_email
    email_body = EmailParser.new(@body)
    receipt_items = email_body.parse_email
    basket = @user.baskets.build(date: @date)
    receipt_items.each { |ri| build_products_and_line_items(basket, ri) }
    basket.total_cents = basket.line_items.collect(&:total_cents).inject { |sum, n| sum + n }
    basket.save
    basket
  end

  def build_products_and_line_items(basket, info)
    return if info.nil?
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
      user: @user,
      product: product,
      price_cents: price,
      quantity: info[:quantity],
      weight: weight,
      total_cents: info[:total_cents],
      discount_cents: info[:disc]
    )
  end
end
