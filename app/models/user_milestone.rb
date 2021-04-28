class UserMilestone < ApplicationRecord
  belongs_to :user
  belongs_to :milestone

  after_commit :publish_to_slack, on: :create, unless: :published_to_slack?

  def publish_to_slack
    # call the slack service bg job
  end 
end