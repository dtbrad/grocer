class GraphConfig
  include ActiveModel::Model

  attr_accessor :start_date, :end_date, :unit

  validate :proper_dates
  validate :proper_unit

  def initialize(params = {})
    @start_date = params.fetch(:start_date, (Time.now - 6.months))
    @end_date = params.fetch(:end_date, Time.now)
    @unit = params.fetch(:unit, 'months')
  end

  def proper_dates
    start_date = Time.parse(@start_date)
    end_date = Time.parse(@end_date)
    return unless end_date < start_date
    errors.add(:start_date, 'cannot be after the end date')
  end

  def proper_unit
    start_date = Time.parse(@start_date)
    end_date = Time.parse(@end_date)
    if end_date - start_date < 604_800 && @unit != 'days'
      errors.add(:unit, 'ranges under a week must be shown in days')
    elsif end_date - start_date < 2_592_000 && @unit == 'months'
      errors.add(:unit, 'ranges under a month must be shown in weeks or days')
    end
  end
end
