class LineItem < ApplicationRecord
  belongs_to :basket
  belongs_to :product
  belongs_to :user
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
    joins(:basket).where(baskets: { transaction_date: start_date..end_date })
  end

  def self.group_line_items(obj)
    start_date = obj.start_date.class == DateTime ? obj.start_date : DateTime.parse(obj.start_date)
    end_date = obj.end_date.class == DateTime ? obj.end_date : DateTime.parse(obj.end_date)
    group_by_period(obj.unit.to_s, 'line_items.transaction_date', range: start_date..end_date).sum('line_items.quantity').to_a
  end

  def formatted_weight
    "#{weight} lb" unless weight.nil?
  end

  def self.total_spent
    sum('total_cents')
  end

  def self.custom_sort(category, direction)
    direction = 'asc'.casecmp(direction).zero? ? 'asc' : 'desc'
    if category == "sort_date"
      send("sort_date", direction)
    else
      attribute_sort(category, direction)
    end
  end

  def self.sort_date(direction)
    order = ["baskets.transaction_date", direction].join(" ")
    joins(:basket).order(order)
  end

  def self.attribute_sort(attribute, direction)
    attribute = sanitize_sql(attribute)
    order(attribute + ' ' + direction)
  end

  def self.oldest
    order(:transaction_date).first
  end
end
