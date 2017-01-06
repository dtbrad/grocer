class Basket < ApplicationRecord
  belongs_to :user
  has_many :line_items, dependent: :destroy
  has_many :products, through: :line_items
  validates :date, presence: true

  def self.create_basket(user, date)
    emails = grab_emails(user, date)
    emails.each do |email|
      next if Basket.find_by(user: user, date: email.date)
      basket = user.baskets.build(date: DateTime.parse(email.date))
      rows = get_the_right_rows(email)
      rows.length.times do |i|
        info = get_data(rows, i)
        basket.build_products_and_line_items(info)
      end
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

      info = { name: rows[i].css('.basket-item-desc').text.rstrip.lstrip }
      unit_pricing = rows[i + 1] && rows[i + 1].css('span').text.include?('$')
      has_weight_unit = rows[i + 1] && rows[i + 1].text.include?('@')

      if !unit_pricing
        info[:price_cents] = rows[i].css('.basket-item-amt').text.to_f * 100
        info[:quantity] = rows[i].css('.basket-item-qty').text.to_i
        info[:quantity] = 1 unless info[:quantity].nonzero?

      elsif unit_pricing && !has_weight_unit
        info[:price_cents] = rows[i + 1].text[/\$\s*(\d+\.\d+)/, 1].to_f * 100
        info[:quantity] = rows[i].css('.basket-item-qty').text.to_i

      elsif unit_pricing && has_weight_unit
        info[:price_cents] = rows[i + 1].text[ /\$\s*(\d+\.\d+)/, 1 ].to_f * 100
        info[:quantity] = rows[i].css('.basket-item-qty').text.to_i
        info[:weight] = rows[i + 1].text[/([\d.]+)\s/].to_f

      end
      info
    end
  end

  def build_products_and_line_items(info)
    unless info.nil?
      product = Product.find_or_create_by(name: info[:name])
      line_items.build(
        product: product,
        price_cents: info[:price_cents],
        quantity: info[:quantity],
        weight: info[:weight]
      )
    end
  end

  def self.custom_sort(category, direction, user)
    # binding.pry
    if category == "items"
      baskets = user.baskets.sort_by_quantity(direction, user)
    elsif category == "total"
      baskets = user.baskets.sort_by_total(direction, user)
    # elsif Basket.column_names.include?(category)
    elsif category == "date"
      baskets = user.baskets.order(category + " " + direction)
    else
      baskets = user.baskets
    end
  end

  def total
    Money.new(line_items.total_spent)
  end

  def quantity
    line_items.sum('quantity')
  end

  def self.sort_by_total(direction, user)
    if direction == "desc"
      baskets = user.baskets.sort_by{|b| b.total}.reverse
    else
      baskets = user.baskets.sort_by{|b| b.total}
    end
  end

  def self.sort_by_quantity(direction, user)
    if direction == "desc"
      baskets = user.baskets.sort_by{|b| b.quantity}.reverse
    else
      baskets = user.baskets.sort_by{|b| b.quantity}
    end
  end

  def self.sort_by_date(direction, user)
    if direction == "desc"
      baskets = user.baskets.sort_by{|b| b.date}.reverse
    else
      baskets = user.baskets.sort_by{|b| b.date}
    end
  end



  # def self.sort_by_basket_qty(direction, user)
  #   if direction == "desc"
  #     all.where(user: user).sort_by{|b| b.}
end
