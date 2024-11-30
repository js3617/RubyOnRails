class Payment < ApplicationRecord
  belongs_to :user
  has_many :payment_items, dependent: :destroy
  has_many :courses, through: :payment_items

  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :status, presence: true, inclusion: { in: %w[pending completed failed] }
  validates :transaction_id, uniqueness: true, allow_nil: true
  validates :payment_method, inclusion: { in: %w[card bank_transfer mobile kakaopay tosspay free], allow_nil: true }
  validates :pg_provider, presence: true, if: -> { transaction_id.present? }

  def pending?
    status == "pending"
  end

  def completed?
    status == "completed"
  end

  def failed?
    status == "failed"
  end
end
