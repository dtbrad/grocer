class SpendingState
  include ActiveModel::Model

  attr_reader :graph_config, :basket_helper_start, :basket_helper_end, :basket_helper_unit, :sort_column,
              :sort_direction, :tooltip_date, :tooltip_unit, :default_start

  def initialize(default_start, options = {})
    @graph_config = options[:graph_config]
    @basket_helper_start = options[:start]
    @basket_helper_end = options[:end]
    @basket_helper_unit = options[:unit]
    @sort_column = init_sort_column(options[:sort_column])
    @sort_direction = init_sort_direction(options[:sort_direction])
    @tooltip_date = options["tooltip_date"]
    @tooltip_unit = options["tooltip_unit"]
    @default_start = default_start
  end

  def set_graph
    if !graph_config && !basket_helper_start && !tooltip_date # html
      GraphConfig.new(user_default_graph)
    elsif graph_config # graph update
      GraphConfig.new(graph_config)
    elsif tooltip_date # clicked on graph plot point
      GraphConfig.new(tooltip_graph)
    else # sorting & pagination
      GraphConfig.new(start_date: basket_helper_start, end_date: basket_helper_end, unit: basket_helper_unit)
    end
  end

  def ending_date(start_date)
    if tooltip_unit == 'week'
      (Date.parse(start_date) + 1.month).to_s
    else
      (Date.parse(start_date) + 1.week).to_s
    end
  end

  def user_default_graph
    { start_date: default_start.to_s, end_date: DateTime.now.to_s, unit: default_unit(default_start) }
  end

  def default_unit(default_start)
    default_start = default_start.to_datetime
    if DateTime.now - default_start < (15 / 1)
      "day"
    elsif DateTime.now - default_start < (30 / 1)
      "week"
    else
      "month"
    end
  end

  def tooltip_graph
    start_date = (Date.parse(tooltip_date) + 1.day).to_s
    end_date = ending_date(start_date)
    { start_date: start_date, end_date: end_date, unit: tooltip_unit }
  end

  def init_sort_column(col)
    col ? col : 'sort_date'
  end

  def init_sort_direction(dir)
    dir && %w[asc desc].include?(dir) ? dir : 'desc'
  end
end
