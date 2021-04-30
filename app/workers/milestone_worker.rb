class MilestoneWorker
  include Sidekiq::Worker

  def perform(message, id)
    SlackService.send_slack_notification(message: message)

    user_milestone = UserMilestone.find_by_id(id)
    user_milestone&.update_attribute(:published_to_slack, true)
  end
end
