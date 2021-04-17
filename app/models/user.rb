class User < ApplicationRecord
  belongs_to :role
  has_and_belongs_to_many :projects
  has_many :activities
  has_many :points_requests, through: :activities
end
