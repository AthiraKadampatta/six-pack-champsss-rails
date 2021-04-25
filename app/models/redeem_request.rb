class RedeemRequest < ApplicationRecord
  belongs_to :user
  has_one :points_transaction, as: :transactable

  validates :points, numericality: { greater_than: 0 }

  after_create :debit_points!

  def debit_points!
    PointsTransaction.create!(transactable: self, txn_type: 'debit', points: points, user_id: user_id)
  end
end
