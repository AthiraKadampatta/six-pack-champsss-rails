class SlackService
  def self.send_slack_notification(vars)
    send_message(vars)
  end

  def self.send_message(vars)
    recipient_id = slack_recipient(vars[:email], vars[:channel])
    body = { text: replace_html_tag(vars[:message]), channel: recipient_id }
    body[:attachments] = vars[:attachments] if vars[:attachments].present?

    Faraday.post(SLACK_INCOMING_WEBHOOK, body.to_json, {"Content-type": "application/json"})
  end

  def self.replace_html_tag(message)
    ActionView::Base.new(nil, {}, nil).strip_tags(message.gsub('</br>', "\n").gsub("&nbsp;", ""))
  end

  def self.slack_recipient(email, channel)
    channel = email.present? ? get_slack_id(SLACK_EMAIL_OVERRIDE || email) : slack_channel_name(channel)
    channel || SLACK_EMAIL_OVERRIDE
  end

  def self.slack_channel_name(base = nil)
    return SLACK_EMAIL_OVERRIDE if base.blank?
    SLACK_CHANNEL_PREFIX + base
  end

  def self.get_slack_id(email)
    user_data = get_slack_member_details(email)
    user_data['id'] if user_data
  end

  def self.get_slack_member_name(email)
    user_data = get_slack_member_details(email)
    user_data['profile']['real_name'] if user_data
  end

  def self.get_slack_member_details(email)
    response = Faraday.get('https://slack.com/api/users.lookupByEmail', params: { 'token' => SLACK_APP_TOKEN, 'email' => email })

    user_data = ActiveSupport::JSON.decode(response)
    user_data["user"]
  end
end
