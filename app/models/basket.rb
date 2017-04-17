class Basket < ApplicationRecord
  belongs_to :user, optional: true
  has_many :line_items
  has_many :products, through: :line_items
  validates :date, presence: true
  paginates_per 10

  def self.from_graph(start_date, end_date, unit)
    Basket.where(date: start_date..end_date)
  end

  def self.average_total
    average(:total_cents) / 100 if  average(:total_cents)
  end

  def self.group_baskets(start_date, end_date, unit)
    if unit == "months"
      group_by_month(:date, range: start_date..end_date).sum('baskets.total_cents / 100')
    elsif unit == "weeks"
      group_by_week(:date, range: start_date..end_date).sum('baskets.total_cents / 100')
    else
      group_by_day(:date, range: start_date..end_date).sum('baskets.total_cents / 100')
    end
  end

  def self.average_time_between_trips
    dates = select(:date).order(date: :asc).collect{|d| d.date}
    if dates.length == 1
      return 10000
    elsif
      dates.length == 0
      return nil
    else
      last = (dates.length) -1
      diff_arr = []
      dates.each_with_index do |val, index|
        if index < last
          diff_arr.push((dates[index+1].to_date - dates[index].to_date).to_i)
        end
      end
      return (diff_arr.inject(0){|sum,x| sum + x }.to_f / diff_arr.length).round.abs unless diff_arr.empty?
    end
  end

  def self.custom_sort(category, direction)
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
    a = select('baskets.*')
      .joins(:line_items)
      .group('baskets.id')
      .order("SUM(line_items.quantity) #{direction}")
  end

  def self.sort_total(direction)
    select('baskets.*')
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
