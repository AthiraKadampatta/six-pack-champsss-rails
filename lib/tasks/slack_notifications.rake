namespace :slack_notifications do
  task top_contributors_of_week: :environment do
    slack_notification_message = Activity.slack_notification_message

    SlackService.send_slack_notification(
      message: slack_notification_message
    ) if slack_notification_message
  end
end
