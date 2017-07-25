class Basket < ApplicationRecord
  belongs_to :user, optional: true
  has_many :line_items
  has_many :products, through: :line_items
  validates :date, presence: true
  monetize :total_cents, as: 'total', disable_validation: true
  paginates_per 10

  def self.from_graph(graph_config)
    start_date = if graph_config.start_date.class == DateTime
                   graph_config.start_date
                 else
                   DateTime.parse(graph_config.start_date)
                 end
    end_date = graph_config.end_date.class == DateTime ? graph_config.end_date : DateTime.parse(graph_config.end_date)
    Basket.where(date: start_date..end_date)
  end

  def self.group_baskets(obj)
    x = group_by_period(obj.unit.to_s, :date, range: obj.start_date..obj.end_date).sum('baskets.total_cents').to_a
    # binding.pry
    x
  end

  def self.custom_sort(category, direction)
    direction = 'asc'.casecmp(direction).zero? ? 'asc' : 'desc'
    send(category, direction)
  end

  def self.sort_date(direction)
    order = ["baskets.date", direction].join(" ")
    order(order)
  end

  def self.sort_items(direction)
    order = ["SUM(line_items.quantity)", direction].join(" ")
    joins(:line_items).group('baskets.id').order(order)
  end

  def self.sort_total(direction)
    order = ["baskets.total_cents", direction].join(" ")
    order(order)
  end

  def discount?
    line_items.find { |li| li.discount != 0 }
  end

  def quantity
    line_items.sum('quantity')
  end
end

# _____Unused methods____________________________________________________________
# def self.average_total
#   average(:total_cents) / 100 if average(:total_cents)
# end
# def self.average_time_between_trips
#   dates = select(:date).order(date: :asc).collect(&:date)
#   if dates.length == 1
#     10_000
#   elsif dates.length.zero?
#     nil
#   else
#     last = dates.length - 1
#     diff_arr = []
#     dates.each_with_index do |_val, index|
#       if index < last
#         diff_arr.push((dates[index + 1].to_date - dates[index].to_date).to_i)
#       end
#     end
#     return (diff_arr.inject(0) { |sum, x| sum + x }.to_f / diff_arr.length).round.abs unless diff_arr.empty?
#   end
# end
