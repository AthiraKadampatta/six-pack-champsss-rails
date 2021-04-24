class PointsTransaction < ApplicationRecord
  belongs_to :user
  belongs_to :transactable, polymorphic: true
end
