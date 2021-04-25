class Activity < ApplicationRecord
  include AASM

  belongs_to :user
  belongs_to :project
  has_one :points_transaction, as: :transactable

  enum status: [:pending, :approved, :rejected]

  aasm column: :status, enum: true do
    state :pending, initial: true
    state :approved
    state :rejected

    event :approve do
      transitions from: :pending,
        to: :approved,
        after: :credit_points
    end

    event :reject do
      transitions from: :pending,
        to: :rejected
    end
  end

  def credit_points
    # TODO
    # Create a points_transaction of type credit
  end
end
