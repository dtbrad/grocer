class Basket < ApplicationRecord
  has_many :line_items
  has_many :products, through: :line_items

  def self.create_basket(username, password)
    gmail = Gmail.connect(username, password)
    all_emails = gmail.inbox.emails(:from => "receipts@newseasonsmarket.com")
    all_emails.each do |email|
      basket = Basket.create(date: email.date)
      body = Nokogiri::HTML(email.body.decoded)
      wanted_rows = body.xpath('//tr[td[(@class = "basket-item-qty") and normalize-space()]
      and td[(@class = "basket-item-desc") and normalize-space()]
      and td[(@class = "basket-item-amt") and normalize-space()]]')

      wanted_rows.each do |r|
        quantity = r.css('.basket-item-qty').text.to_f
        quantity = 1 unless quantity != 0
        description = r.css('.basket-item-desc').text.rstrip!.lstrip!
        price = r.css('.basket-item-amt').text.to_f
        product = Product.find_or_create_by(name: description)
        line_item = basket.line_items.build(
          quantity: quantity,
          price: price / quantity,
          product_id: product.id
        )
      end
      basket.save
    end
  end

end
