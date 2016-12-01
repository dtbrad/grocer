class Basket < ApplicationRecord
  belongs_to :user
  has_many :line_items, dependent: :destroy
  has_many :products, through: :line_items
  validates :date, presence: true

  def self.create_basket(user, date)
    gmail = Gmail.connect(:xoauth2, user.email, user.oauth_token)
    emails = gmail.inbox.emails(
      from: 'receipts@newseasonsmarket.com',
      after: Date.parse(date)
    )
    emails.each do |email|
      get_the_right_rows(email, user) unless Basket.find_by(date: email.date)
    end
  end

  def self.get_the_right_rows(email, user)
    basket = user.baskets.build(date: DateTime.parse(email.date))
    body = Nokogiri::HTML(email.body.decoded)
    wanted_rows = body.xpath(
      '//tr[td[(@class = "basket-item-qty") and normalize-space()]
      and td[(@class = "basket-item-desc") and normalize-space()]
      and td[(@class = "basket-item-amt") and normalize-space()]]'
    )
    extract_line_item_info(wanted_rows, basket)
    basket.save
  end

  def self.extract_line_item_info(wanted_rows, basket)
    wanted_rows.each do |r|
      quantity = r.css('.basket-item-qty').text.to_f
      quantity = 1 unless quantity.nonzero?
      description = r.css('.basket-item-desc').text.rstrip!.lstrip!
      price = r.css('.basket-item-amt').text.to_f * 100
      build_products_and_line_items(basket, quantity, description, price)
    end
  end

  def self.build_products_and_line_items(basket, quantity, description, price)
    # binding.pry
    product = Product.find_or_create_by(name: description)
    basket.line_items.build(
      quantity: quantity,
      price_cents: price / quantity,
      product_id: product.id
    )
  end

  def total
    amount = 0
    line_items.each { |li| amount += li.price * li.quantity }
    amount
  end
end
