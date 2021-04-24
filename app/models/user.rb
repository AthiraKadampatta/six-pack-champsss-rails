class User < ApplicationRecord
  # belongs_to :role
  has_and_belongs_to_many :projects
  has_many :activities
  has_many :points_transactions
  has_many :redeem_requests
  
  after_initialize :set_default_role, :if => :new_record?
  enum role_id: ['owner', 'admin', 'associate']

  def set_default_role
    self.role_id = :associate
  end
end
