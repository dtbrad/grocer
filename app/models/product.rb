class Product < ApplicationRecord
  has_many :line_items, dependent: :destroy
  has_many :baskets, through: :line_items
  # has_many :users, through: :baskets
  has_many :users, -> { distinct }, through: :line_items
  validates :name, presence: true

  def times_bought
    line_items.inject(0) do |sum, l|
      l.quantity % 1 == 0 ? quantity = l.quantity : quantity = 1
      sum + quantity
    end
  end

  def highest_price
    line_items.order(:price_cents).last.price
  end

  def lowest_price
    line_items.order(:price_cents).first.price
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

end
