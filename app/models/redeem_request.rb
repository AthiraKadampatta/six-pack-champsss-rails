class RedeemRequest < ApplicationRecord
  include AASM

  belongs_to :user
  has_one :points_transaction, as: :transactable

  validates :points, numericality: { greater_than: 0 }

  after_create :debit_points!

  enum status: [:pending, :completed]

  aasm column: :status, enum: true do
    state :pending, initial: true
    state :completed

    event :complete do
      transitions from: :pending, to: :completed
    end
  end

  def debit_points!
    PointsTransaction.create!(transactable: self, txn_type: :debit, points: points, user_id: user_id)
  end
end
