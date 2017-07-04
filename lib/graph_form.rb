class GraphForm
  include ActiveModel::Model

  attr_accessor :start_date, :end_date, :unit

  validate :proper_dates
  validate :proper_unit

  def initialize(obj)
    @start_date = obj[:start_date].class == Time ? obj[:start_date] : Time.parse(obj[:start_date])
    @end_date = obj[:end_date].class == Time ? obj[:end_date] : Time.parse(obj[:end_date])
    @unit = obj[:unit]
  end

  def proper_dates
    return unless end_date < start_date
    errors.add(:start_date, 'cannot be after the end date')
  end

  def proper_unit
    if @end_date - @start_date < 604_800 && @unit != 'days'
      errors.add(:unit, 'ranges under a week must be shown in days')
    elsif @end_date - @start_date < 2_592_000 && @unit == 'months'
      errors.add(:unit, 'ranges under a month must be shown in weeks or days')
    end
  end
end
