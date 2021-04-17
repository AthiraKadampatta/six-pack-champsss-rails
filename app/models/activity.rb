class Activity < ApplicationRecord
  belongs_to :user
  belongs_to :project
  has_one :points_request
end
