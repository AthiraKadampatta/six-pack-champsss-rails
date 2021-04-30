class UserMilestone < ApplicationRecord
  belongs_to :user
  belongs_to :milestone

  after_commit :publish_to_slack, on: :create, unless: :published_to_slack?

  def publish_to_slack
    # adding syncronous due to credit card issue on heroku
    message = "#{user.name} has reached a milestone of #{milestone.value} klaps!! Congratulations :clap:",
    MilestoneWorker.new.perform(message, id)
  end
end
