class LineItem < ApplicationRecord
  belongs_to :basket
  belongs_to :product
  has_one :user, through: :basket
  monetize :price_cents, disable_validation: true
  monetize :total_cents, as: 'total'
  monetize :discount_cents, as: 'discount'
  validates :price_cents, presence: true
  validates :quantity, presence: true
  validates_presence_of :product, :basket
  paginates_per 10

  def self.from_graph(graph_config)
    start_date = graph_config.start_date.class == DateTime ? graph_config.start_date : DateTime.parse(graph_config.start_date)
    end_date = graph_config.end_date.class == DateTime ? graph_config.end_date : DateTime.parse(graph_config.end_date)
    joins(:basket).where(baskets: { date: start_date..end_date })
  end

  def self.group_line_items(obj)
    start_date = obj.start_date.class == DateTime ? obj.start_date : DateTime.parse(obj.start_date)
    end_date = obj.end_date.class == DateTime ? obj.end_date : DateTime.parse(obj.end_date)
    group_by_period(obj.unit.to_s, :date, range: start_date..end_date).sum('line_items.quantity')
  end

  def formatted_weight
    "#{weight} lb" unless weight.nil?
  end

  def self.total_spent
    sum('total_cents')
  end

  def self.custom_sort(category, direction)
    direction = direction.downcase == 'asc' ? 'asc' : 'desc'
    if category == 'date_purchased'
      line_items = select('line_items.*').joins(:basket).order("baskets.date #{direction}")
    elsif LineItem.column_names.include?(category)
      category = sanitize_sql(category)
      line_items = select('line_items.*').order(category + ' ' + direction)
    else
      line_items = select('line_items.*').joins(:basket).order('baskets.date desc')
    end
    line_items
  end
end
