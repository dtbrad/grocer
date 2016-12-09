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
      '//tr[(td[(@class = "basket-item-qty") and normalize-space()]
      and td[(@class = "basket-item-desc") and normalize-space()]
      and td[(@class = "basket-item-amt") and normalize-space()]) or td[span]]'
    )
    extract_line_item_info(wanted_rows, basket)
    basket.save
  end

  def self.extract_line_item_info(wanted_rows, basket)
    length = wanted_rows.length
    length.times do |i|
      if !wanted_rows[i].css('span').text.include?("$")
        if wanted_rows[i+1] && wanted_rows[i+1].css('span').text.include?("$")
          description = wanted_rows[i].css('.basket-item-desc').text.rstrip!.lstrip!
          price = wanted_rows[i+1].text[ /\$\s*(\d+\.\d+)/, 1 ].to_f * 100
          if wanted_rows[i+1].text.include?("@")
            quantity = 1
            weight = wanted_rows[i+1].text[/([\d.]+)\s/].to_f
          else
            quantity = wanted_rows[i].css('.basket-item-qty').text.to_f
          end
        else
          description = wanted_rows[i].css('.basket-item-desc').text.rstrip!.lstrip!
          price = wanted_rows[i].css('.basket-item-amt').text.to_f * 100
          quantity = wanted_rows[i].css('.basket-item-qty').text.to_f
          quantity = 1 unless quantity.nonzero?
        end
        quantity = 1 unless quantity.nonzero?
        build_products_and_line_items(basket, quantity, weight, description, price)
      end
    end
  end

  def self.build_products_and_line_items(basket, quantity, weight, description, price)
    if description != nil
      product = Product.find_or_create_by(name: description)
      basket.line_items.build(
        quantity: quantity,
        weight: weight,
        price_cents: price,
        product_id: product.id
      )
    end
  end

  def total
    amount = 0
    line_items.each { |li| amount += li.price * li.quantity }
    amount
  end
end
