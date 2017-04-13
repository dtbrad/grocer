class Basket < ApplicationRecord
  belongs_to :user, optional: true
  has_many :line_items
  has_many :products, through: :line_items
  validates :date, presence: true
  paginates_per 10

  def self.from_graph(unit, duration)
    if unit == "months"
      Basket.where("date > ?", duration.to_i.months.ago)
    else
      Basket.where("date > ?", duration.to_i.weeks.ago)
    end
  end

  def self.group_baskets(duration, unit)
    if unit == "months"
      group_by_month(:date, last: duration.to_i+1).sum('baskets.total_cents / 100')
    else
      group_by_week(:date, last: duration.to_i+1).sum('baskets.total_cents / 100')
    end
  end

  def self.custom_sort(category, direction)
    # binding.pry
    # category = category == nil ? 'date' : category
    # direction = direction == nil ? 'desc' : direction
    # binding.pry
    case category
    when 'date'
      sort_date(direction)
    when 'items'
      sort_items(direction)
    when 'total'
      sort_total(direction)
    else
      sort_date('desc')
    end
  end

  def self.sort_date(direction)
    select('baskets.*')
      .order("baskets.date #{direction}")
  end

  def self.sort_items(direction)
    select('baskets.*', 'SUM(line_items.quantity)')
      .joins(:line_items)
      .group('baskets.id')
      .order("SUM(line_items.quantity) #{direction}")
  end

  def self.sort_total(direction)
    select('baskets.*', 'SUM(line_items.total_cents)')
      .joins(:line_items)
      .group('baskets.id')
      .order("SUM(line_items.total_cents) #{direction}")
  end

  def self.remove_user
    all.each {|b| b.update(user_id: nil)}
  end

  def has_discount?
    line_items.find {|li| li.discount !=0 }
  end

  def total
    Money.new(line_items.total_spent)
  end

  def quantity
    line_items.sum('quantity')
  end
end
