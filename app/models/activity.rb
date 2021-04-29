class Activity < ApplicationRecord
  include AASM

  belongs_to :user
  belongs_to :project
  has_one :points_transaction, as: :transactable

  before_update :prevent_unless_status_pending, unless: -> { status_changed? }

  enum status: [:pending, :approved, :rejected]

  aasm column: :status, enum: true do
    state :pending, initial: true
    state :approved
    state :rejected

    event :approve do
      transitions from: :pending,
        to: :approved,
        after: [:credit_points!, :add_milestone]
    end

    event :reject do
      transitions from: :pending,
        to: :rejected
    end
  end

  def credit_points!
    PointsTransaction.create!(transactable: self, txn_type: :credit, points: points_granted, user_id: user_id)
  end

  def add_milestone
    user.add_milestone
  end

  def prevent_unless_status_pending
    unless pending?
      errors.add(:base, "Cannot update #{status} activity")
      throw(:abort)
    end
  end
end
