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

  def self.weekly_top_five_contibutors
    prev_week_start_date = 1.week.ago.to_date
    @weekly_top_five_contibutors ||=
      ActiveRecord::Base.connection
        .exec_query("SELECT users.name, sum(activities.points_granted) as total_points
        FROM \"users\" INNER JOIN \"activities\"
        ON \"activities\".\"user_id\" = \"users\".\"id\"
        WHERE \"activities\".\"status\" = 1 AND \"activities\".\"reviewed_at\" >= '#{prev_week_start_date}'
        GROUP BY \"users\".\"id\"
        ORDER BY \"total_points\" DESC;").rows
  end

  def self.slack_notification_message
    message = "*Top 5 Klap earners of week* :clap: :clap:"
    weekly_top_five_contibutors.each do |name, points|
      message << "\n\n#{name}:  #{points} points :tada:"
    end

    message if weekly_top_five_contibutors.any?
  end
end
