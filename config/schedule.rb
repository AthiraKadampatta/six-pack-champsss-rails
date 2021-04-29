every 1.minute do
  rake "slack_notifications:top_contributors_of_week"
end
