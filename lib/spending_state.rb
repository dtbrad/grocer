class SpendingState
  include ActiveModel::Model

  attr_accessor :graph_config, :start, :end, :unit

  def initialize(options = {})
    @graph_config = options[:graph_config]
    @start = options[:start]
    @end = options[:end]
    @unit = options[:unit]
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
end
