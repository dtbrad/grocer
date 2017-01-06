class Product < ApplicationRecord
  has_many :line_items, dependent: :destroy
  has_many :baskets, through: :line_items
  has_many :users, through: :baskets
  validates :name, presence: true

  def self.custom_sort(category, direction, user)
    products = select('products.*', 'SUM(line_items.quantity) as line_items_sum').group('products.id')
    if category == "times_bought"
      products = products.sort_by_qty(direction)
    elsif category == "highest_price"
      products = products.sort_by_highest_price(direction, user)
    elsif category == "lowest_price"
      products = products.sort_by_lowest_price(direction, user)
    elsif category == "most_recently_purchased"
      products = products.sort_by_last_purchase(direction, user)
    elsif Product.column_names.include?(category)
      products = products.order(category + " " + direction)
    end
    products
  end

  def times_bought(user)
    user.line_items.where(product: self).sum(:quantity)
  end

  def self.sort_by_highest_price(direction, user)
    if direction == "desc"
      distinct.sort_by{|p| p.highest_price_by_user(user)}.reverse
    else
      distinct.sort_by{|p| p.highest_price_by_user(user)}
    end
  end

  def self.sort_by_lowest_price(direction, user)
    if direction == "desc"
      distinct.sort_by{|p| p.lowest_price_by_user(user)}.reverse
    else
      distinct.sort_by{|p| p.lowest_price_by_user(user)}
    end
  end

  def self.sort_by_last_purchase(direction, user)
    if direction == "desc"
      distinct.sort_by{|p| p.most_recently_purchased(user)}.reverse
    else
      distinct.sort_by{|p| p.most_recently_purchased(user)}
    end
  end

  def highest_price
    line_items.order(price_cents: :desc).first.price
  end

  def highest_price_by_user(user)
    line_items.where(basket: Basket.where(user: user)).order(:price_cents).last.price
  end

  def lowest_price
    line_items.order(:price_cents).first.price
  end

  def lowest_price_by_user(user)
    line_items.where(basket: Basket.where(user: user)).order(:price_cents).first.price
  end

  def self.most_expensive_product
    LineItem.order(:price_cents).last.product
  end

  def self.most_expensive_product_by_user(user)
    LineItem.where(basket: Basket.where(user: user)).order(price_cents: :desc).first.product
  end

  def self.least_expensive_product
    LineItem.order(:price_cents).first.product
  end

  def self.least_expensive_product_by_user(user)
    LineItem.where(basket: Basket.where(user: user)).order(:price_cents).first.product
  end

  def self.sort_by_qty(direction)
    order("line_items_sum #{direction}")
  end

  def self.most_popular_product
    joins(:line_items).group('products.id').order('SUM(quantity)').last
  end

  def self.stable_price
    x = all.select {|p| p.line_items.collect {|l| l.price}.uniq.count > 1}
    x.each {|p| puts p.name}
  end

  def most_recently_purchased(user)
    baskets.where(user: user).order(:date).last.date
  end

  def this_users_line_items(user)
    line_items.where(basket: Basket.where(user: user))
  end

  def self.most_popular_product
    filtered_products.joins(:line_items).group('products.id').order('SUM(quantity)').last
  end

  def self.filtered_products
    Product.where.not(name: ['$10 OFF COUPON', '25% WINE DISCOUNT', 'BAG REFUND', 'BAG IT FORWARD', '$5 off $30 offer', '$5 OFF COUPON', 'BEER DEPOSIT 30C'])
  end

end
