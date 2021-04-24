class RedeemRequest < ApplicationRecord
  belongs_to :user
  has_one :points_transaction, as: :transactable
end
