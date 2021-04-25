class User < ApplicationRecord
  attribute :role, default: :associate

  has_and_belongs_to_many :projects
  has_many :activities
  has_many :points_transactions
  has_many :redeem_requests
  
  enum role: ['owner', 'admin', 'associate']

  validates :email, presence: true, uniqueness: true

  before_create :extract_name_from_email

  private

  def extract_name_from_email
    return if name.present?
    self.name = email.split('@').first.titleize
  end
end
