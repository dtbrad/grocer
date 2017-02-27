class NickNameRequest < ApplicationRecord
  belongs_to :product
  belongs_to :user
  enum status: [:unreviewed, :approved, :rejected]

  after_initialize :set_default_status, if: :new_record?

  def set_default_status
    self.status ||= :unreviewed
  end
end
