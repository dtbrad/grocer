class SpendingState
  include ActiveModel::Model

  attr_reader :graph_config, :start, :end, :unit, :sort_column, :sort_direction, :tooltip_date, :tooltip_unit

  def initialize(options = {})
    # binding.pry
    @graph_config = options[:graph_config]
    @start = options[:start]
    @end = options[:end]
    @unit = options[:unit]
    @sort_column =  init_sort_column(options[:sort_column])
    @sort_direction = init_sort_direction(options[:sort_direction])
    @tooltip_date = options["tooltip_date"]
    @tooltip_unit = options["tooltip_unit"]
  end

  def set_graph
    if @graph_config
      GraphConfig.new(@graph_config)
    elsif !@graph_config && !@start && !@tooltip_date
      GraphConfig.new
    elsif @tooltip_date
      # range = tooltip_range
      start_date = (Date.parse(tooltip_date) + 1.day).to_s
      # end_date = (Date.parse(start_date) + 1.month).to_s
      end_date = ending_date(start_date)
      # binding.pry
      GraphConfig.new(start_date: start_date, end_date: end_date, unit: @tooltip_unit)
    else
      GraphConfig.new(start_date: @start, end_date: @end, unit: @unit)
    end
  end

  def ending_date(start_date)
    # binding.pry
    if tooltip_unit == 'week'
      (Date.parse(start_date) + 1.month).to_s
    else
      (Date.parse(start_date) + 1.week).to_s
    end
  end

  def init_sort_column(col)
    col ? col : 'sort_date'
  end

  def init_sort_direction(dir)
    dir && %w[asc desc].include?(dir) ? dir : 'desc'
  end
end
