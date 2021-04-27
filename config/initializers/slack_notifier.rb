module Notifier
  class << self
    attr_accessor :config
  end
end

Notifier.config = YAML.load_file("#{Rails.root}/config/slack_notifier.yml")[Rails.env].symbolize_keys

SLACK_INCOMING_WEBHOOK = Notifier.config[:slack_incoming_webhook]
SLACK_APP_TOKEN = Notifier.config[:slack_app_token]
SLACK_EMAIL_OVERRIDE = Notifier.config[:slack_email_override]
SLACK_CHANNEL_PREFIX = Notifier.config[:slack_channel_prefix]
