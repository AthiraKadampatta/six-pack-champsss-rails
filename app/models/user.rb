class User < ApplicationRecord
  has_and_belongs_to_many :projects
  has_many :activities
  has_many :points_transactions
  has_many :redeem_requests
  
  after_initialize :set_default_role, :if => :new_record?
  enum role: ['owner', 'admin', 'associate']

  def set_default_role
    self.role = :associate
  end
end
