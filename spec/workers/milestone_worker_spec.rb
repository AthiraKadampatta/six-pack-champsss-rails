require 'rails_helper'
RSpec.describe MilestoneWorker, type: :worker do
  describe '#perform' do
    it 'send slack notification' do
      expect(SlackService).to receive(:send_slack_notification)
      MilestoneWorker.new.perform("test message", 1)
    end
  end
end
