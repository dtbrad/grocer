class NickNameRequest < ApplicationRecord
  belongs_to :product
  belongs_to :user
  enum status: %i[unreviewed approved rejected]

  after_initialize :set_default_status, if: :new_record?

  def set_default_status
    self.status ||= :unreviewed
  end

  def self.process_request(request, params)
    request.update(status: params[:nick_name_request][:status])
    return unless request.status == 'approved'
    request.product.update(nickname: params[:nick_name_request][:product][:nickname])
  end
end
