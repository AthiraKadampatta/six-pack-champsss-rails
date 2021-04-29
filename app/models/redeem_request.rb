class RedeemRequest < ApplicationRecord
  include AASM

  belongs_to :user
  has_one :points_transaction, as: :transactable

  validates :points, numericality: { greater_than: 0 }
  validate :redeemed_points_not_more_than_available, if: :new_record?

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

  def redeemed_points_not_more_than_available
    if points > user.available_points
      errors.add(:points, "can't be greater than available_points")
    end
  end
end
