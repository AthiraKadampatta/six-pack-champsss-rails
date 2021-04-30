module Notifier
  class << self
    attr_accessor :config
  end
end

Notifier.config = Rails.application.config_for(:slack_notifier)

SLACK_INCOMING_WEBHOOK = Notifier.config[:slack_incoming_webhook]
SLACK_APP_TOKEN = Notifier.config[:slack_app_token]
SLACK_EMAIL_OVERRIDE = Notifier.config[:slack_email_override]
SLACK_CHANNEL_PREFIX = Notifier.config[:slack_channel_prefix]
