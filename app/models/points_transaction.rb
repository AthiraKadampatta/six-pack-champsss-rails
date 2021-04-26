class PointsTransaction < ApplicationRecord
  belongs_to :user
  belongs_to :transactable, polymorphic: true

  enum txn_type: [:credit, :debit]

  def points
    credit? ? self['points'] : -(self['points'])
  end
end
