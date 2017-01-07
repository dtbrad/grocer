class Product < ApplicationRecord
  has_many :line_items, dependent: :destroy
  has_many :baskets, through: :line_items
  has_many :users, through: :baskets
  validates :name, presence: true

  def self.custom_sort(category, direction, user)
    if category == "times_bought"
      products = select('products.*', 'SUM(line_items.quantity) as line_items_sum').
      group('products.id').
      order("line_items_sum #{direction}")
    elsif category == "highest_price"
      products = select('products.*', 'MAX(line_items.price_cents) as max_price').
      group('products.id').
      order("max_price #{direction}")
    elsif category == "lowest_price"
      products = select('products.*', 'MIN(line_items.price_cents) as min_price').
      group('products.id').
      order("min_price #{direction}")
    elsif category == "most_recently_purchased"
      products = select('products.*', 'MAX(baskets.date) as max_date').
      group('products.id').
      order("max_date #{direction}")
    elsif Product.column_names.include?(category)
      products = select('products.*').order(category + " " + direction)
    else
      products = select('products.*').
      group('products.id').
      order('products.name')
    end
    products
  end

  def times_bought(user)
    user.line_items.where(product: self).sum(:quantity)
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
