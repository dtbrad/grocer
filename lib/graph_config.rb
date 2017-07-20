class GraphConfig
  include ActiveModel::Model

  attr_accessor :start_date, :end_date, :unit

  validate :proper_dates
  validate :proper_unit

  def initialize(params = {})
    @start_date = params.fetch(:start_date, (DateTime.now - 24.months))
    @end_date = params.fetch(:end_date, DateTime.now)
    @unit = params.fetch(:unit, 'month')
  end

  def proper_dates
    @start_date = @start_date.class == DateTime ? @start_date : DateTime.parse(@start_date)
    @end_date = @end_date.class == DateTime ? @end_date : DateTime.parse(@end_date)
    # start_date = DateTime.parse(@start_date)
    # end_date = DateTime.parse(@end_date)
    return unless @end_date < @start_date
    errors.add(:start_date, 'cannot be after the end date')
  end

  def proper_unit
    @start_date = @start_date.class == DateTime ? @start_date : DateTime.parse(@start_date)
    @end_date = @end_date.class == DateTime ? @end_date : DateTime.parse(@end_date)
    # start_date = DateTime.parse(@start_date)
    # end_date = DateTime.parse(@end_date)
    if @end_date - @start_date < (7 / 1) && @unit != 'day'
      errors.add(:unit, 'ranges under a week must be shown in days')
    elsif @end_date - @start_date < (30 / 1) && @unit == 'month'
      errors.add(:unit, 'ranges under a month must be shown in weeks or days')
    end
  end
end
