every :monday, at: '10am' do
  rake "slack_notifications:top_contributors_of_week"
end
