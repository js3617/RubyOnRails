class PaymentItem < ApplicationRecord
  belongs_to :payment
  belongs_to :course

  validates :course_id, presence: true
end
