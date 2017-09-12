class EmailDataProcessor
  attr_accessor :date, :body, :user

  def initialize(message)
    @date = message[:date]
    @body = message[:body]
    @user = message[:user]
  end

  def process_single_email
    email_body = EmailParser.new(body)
    receipt_items = email_body.parse_email
    basket = user.baskets.build(date: date)
    receipt_items.each { |ri| build_products_and_line_items(basket, ri) }
    basket.total_cents = basket.line_items.collect(&:total_cents).inject { |sum, n| sum + n }
    basket.fishy_total = true if EmailDataProcessor.fishy_total?(basket, body)
    basket.save
    basket
  end

  def self.fishy_total?(basket, body)
    total_from_email = (EmailParser.total_string(body).delete("$").to_d * 100).to_i
    (basket.total_cents - total_from_email).abs > 30
  end

  def build_products_and_line_items(basket, info)
    product = Product.find_or_create_by(name: info[:name].titleize)
    price_info = create_price_info(info, product)
    basket.line_items.build(total_cents: info[:total_cents], quantity: info[:qty], product: product,
                            user: user, price_cents: price_info[:price_cents], weight: price_info[:weight])
  end

  def create_price_info(info, product)
    price_info = { weight: nil }
    if product.real_unit_price_cents
      price_info[:price_cents] = product.real_unit_price_cents
      price_info[:weight] = (info[:total_cents].to_d / product.real_unit_price_cents).round(2)
    elsif info[:weight]
      price_info[:price_cents] = info[:price_per_pound]
      price_info[:weight] = info[:weight]
    elsif info[:unit_price]
      price_info[:price_cents] = info[:unit_price]
    else
      price_info[:price_cents] = info[:total_cents]
    end
    price_info
  end
end
