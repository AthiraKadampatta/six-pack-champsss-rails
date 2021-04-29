namespace :slack_notifications do
  task top_contributors_of_week: :environment do
    top_contributors =  [['Prayesh', 1959], ['Athira', 1200], ['Supriya', 100]]#Activity.weekly_top_five_contibutors
    message = "*Top kudoed contributors of week* :clap: :clap:"

    top_contributors.each do |name, points|
      message << "\n\n:raised_hands: #{name}:  #{points} points"
    end

    SlackService.send_slack_notification(
      message: message
    )
  end
end
