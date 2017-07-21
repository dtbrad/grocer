class SpendingState
  include ActiveModel::Model

  attr_reader :graph_config, :start, :end, :unit, :sort_column, :sort_direction

  def initialize(options = {})
    @graph_config = options[:graph_config]
    @start = options[:start]
    @end = options[:end]
    @unit = options[:unit]
    @sort_column =  init_sort_column(options[:sort_column])
    @sort_direction = init_sort_direction(options[:sort_direction])
  end

  def set_graph
    if @graph_config
      GraphConfig.new(@graph_config)
    elsif !@graph_config && !@start
      GraphConfig.new
    else
      GraphConfig.new(start_date: @start, end_date: @end, unit: @unit)
    end
  end

  def init_sort_column(col)
    col ? col : 'sort_date'
  end

  def init_sort_direction(dir)
    dir && %w[asc desc].include?(dir) ? dir : 'desc'
  end
end
