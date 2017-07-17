class Product < ApplicationRecord
  has_many :line_items, dependent: :destroy
  has_many :baskets, through: :line_items
  has_many :users, through: :baskets
  has_many :nick_name_requests
  monetize :real_unit_price_cents, disable_validation: true
  validates :name, presence: true
  validates :nickname, presence: true
  validates :nickname, uniqueness: true
  validates :nickname, length: { maximum: 30 }
  paginates_per 10
  after_initialize :set_nickname, if: :new_record?

  def self.search(search)
    where('name iLIKE ? OR nickname iLIKE ?', "%#{search}%", "%#{search}%")
  end

  def self.custom_sort(category, direction)
    direction = 'asc'.casecmp(direction).zero? ? 'asc' : 'desc'
    categories = %w[sort_times_bought sort_highest_price sort_highest_price sort_recently_purchased]
    if categories.include?(category)
      send(category, direction)
    else
      sort_nickname(direction)
    end
  end

  def self.sort_times_bought(direction)
    order = ["line_items_sum", direction].join(" ")
    select('products.*', 'SUM(line_items.quantity) as line_items_sum').group('products.id').order(order)
  end

  def self.sort_highest_price(direction)
    order = ["MAX(line_items.price_cents)", direction].join(" ")
    select('products.*', 'MAX(line_items.price_cents)').group('products.id').order(order)
  end

  def self.sort_lowest_price(direction)
    order = ["MIN(line_items.price_cents)", direction].join(" ")
    select('products.*', 'MIN(line_items.price_cents) as min_price').group('products.id').order(order)
  end

  def self.sort_recently_purchased(direction)
    order = ["MAX(baskets.date)", direction].join(" ")
    select('products.*', 'MAX(baskets.date) as max_date').group('products.id').order(order)
  end

  def self.sort_nickname(direction)
    order = ["nickname", direction].join(" ")
    group('products.id').order(order)
  end

  def self.filtered_products
    Product.where.not(name: ['Beer Bottle Dep', 'Beer Deposit 30 C',
                             'Beer Deposit 60 C', '$5 Off $30 Offer',
                             '$10 Off Coupon', '25% Wine Discount',
                             'Bag Refund', 'Bag It Forward', '$5 Off $30 offer',
                             '$5 Off Coupon', 'Beer Deposit 30C', '$6 Off $40 Offer'])
  end

  def self.most_money_spent
    group('products.id')
      .order('sum(line_items.total_cents) desc').limit(10)
      .pluck('products.nickname, sum(line_items.total_cents *.01)')
  end

  def self.most_purchased
    filtered_products
      .group('products.id')
      .order('sum(line_items.quantity) desc').limit(10)
      .pluck('products.nickname, sum(line_items.quantity)')
  end

  def self.process_nick_name_request(user, product, params)
    if user.admin?
      product.update(nickname: params[:product][:nickname])
    else
      product.nick_name_requests.create(user: user, suggestion: params[:product][:nickname])
    end
  end

  def fix_price(new_price_cents)
    line_items.each do |li|
      li.price_cents = new_price_cents
      li.weight = (li.total_cents.to_f / li.price_cents.to_f).round(2)
      li.product.update(real_unit_price_cents: new_price_cents)
      li.save
    end
  end

  def has_line_items?
    line_items.count > 0
  end

  def has_nickname?
    nickname != name ? "#{nickname}" : "None"
  end

  def highest_price
    line_items.order(price_cents: :desc).first.price if has_line_items?
  end

  def highest_price_by_user(user)
    line_items.where(basket: Basket.where(user: user)).order(:price_cents).last.price if has_line_items?
  end

  def highest_price_cents
    line_items.order(price_cents: :desc).first.price_cents if has_line_items?
  end

  def lowest_price
    line_items.order(:price_cents).first.price if has_line_items?
  end

  def lowest_price_by_user(user)
    line_items.where(basket: Basket.where(user: user)).order(:price_cents).first.price if has_line_items?
  end

  def most_recently_purchased(user)
    baskets.where(user: user).order(:date).last.date if has_line_items?
  end

  def set_nickname
    self.nickname = name unless nickname
    save
  end

  def this_users_line_items(user)
    line_items.where(basket: Basket.where(user: user)) if has_line_items?
  end

  def times_bought(user)
    user.line_items.where(product: self).sum(:quantity)
  end
end

# _____Unused methods____________________________________________________________

# def self.most_expensive_product
#   LineItem.order(:price_cents).last.product
# end

# def self.most_expensive_product_by_user(user)
#   LineItem.where(basket: Basket.where(user: user))
#           .order(price_cents: :desc).first.product
# end

# def self.least_expensive_product
#   LineItem.order(:price_cents).first.product
# end

# def self.least_expensive_product_by_user(user)
#   LineItem.where(basket: Basket.where(user: user))
#           .order(:price_cents).first.product
# end

# def self.most_popular_product
#   joins(:line_items).group('products.id').order('SUM(quantity)').last
# end

# def self.stable_price
#   x = all.select { |p| p.line_items.collect { |l| l.price }.uniq.count > 1 }
#   x.each { |p| puts p.name }
# end
