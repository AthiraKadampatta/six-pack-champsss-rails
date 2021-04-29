class User < ApplicationRecord
  attribute :role, default: :associate

  has_and_belongs_to_many :projects
  has_many :activities
  has_many :points_transactions
  has_many :redeem_requests
  has_many :user_milestones
  has_many :milestones, through: :user_milestones

  enum role: ['owner', 'admin', 'associate']

  validates :email, presence: true, uniqueness: true

  before_create :extract_name_from_email

  def total_points
    activities.approved.pluck(:points_granted).inject(0, :+)
  end

  def points_per_project
    activities.approved.joins(:project).select(:name).group(:name).sum(:points_granted)
  end

  def available_points
    points_transactions.inject(0) {|res, pt| res + pt.points}
  end

  def redeemed_points
    points_transactions.debit.inject(0) {|res, pt| res + pt.points}.abs
  end

  def admin_or_owner?
    admin? || owner?
  end

  def add_milestone
    Milestone.desc.each do |milestone|
      if milestone&.value && total_points >= milestone.value
        user_milestones.find_or_create_by!(milestone_id: milestone.id)
        break
      end
    end
  end

  private

  def extract_name_from_email
    return if name.present?
    self.name = email.split('@').first.titleize
  end
end
