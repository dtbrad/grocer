class Product < ApplicationRecord
  has_many :line_items, dependent: :destroy
  has_many :baskets, through: :line_items
  has_many :users, through: :baskets
  validates :name, presence: true

  def times_bought(user)
    user.line_items.where(product: self).sum(:quantity)
  end

  def highest_price
    line_items.order(price_cents: :desc).first.price
  end

  def lowest_price
    line_items.order(:price_cents).first.price
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

  def self.sorted_array
    joins(:line_items).group('products.id').order('SUM(quantity)')
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
    Product.where.not(name: ['BAG REFUND', 'BAG IT FORWARD', '$5 off $30 offer'])
  end

end
