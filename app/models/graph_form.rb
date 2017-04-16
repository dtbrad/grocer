class GraphForm
  include ActiveModel::Model

  attr_accessor :start_date, :end_date, :unit

  validate :proper_dates

  def initialize(obj)
    @start_date = obj[:start_date].class == Time ? obj[:start_date] : Time.parse(obj[:start_date])
    @end_date = obj[:end_date].class == Time ? obj[:end_date] : Time.parse(obj[:end_date])
    @unit = obj[:unit]
  end

  def proper_dates
    if end_date < start_date
      errors.add(:start_date, "cannot be after the end date")
    end
  end

end
