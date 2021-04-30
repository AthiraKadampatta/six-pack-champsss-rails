require "rails_helper"

RSpec.describe User, :type => :model do
  before { allow(SlackService).to receive(:send_slack_notification) }

  it 'assigns default role' do
    user = User.new(email: 'test@email.com')
    expect(user.role).to eq 'associate'
  end

  context 'when name is not passed' do
    it 'sets default name from email' do
      user = User.create(email: 'test.user@email.com')
      expect(user.name).to eq 'Test.User'
    end
  end

  context 'when name is passed' do
    it 'sets the passed name' do
      user = User.create(email: 'test.user@email.com', name: 'ABC')
      expect(user.name).to eq 'ABC'
    end
  end

  describe 'add_milestone' do
    let(:user) { users(:associate_one) }
    let(:first_milestone) { milestones(:milestone_1).value }
    let(:second_milestone) { milestones(:milestone_2).value }

    context 'when user total_points has not reached milestone' do
      before { allow(user).to receive(:total_points).and_return(first_milestone - 1) }

      it 'does not create user milestone record' do
        expect{ user.add_milestone }.not_to change { UserMilestone.count }
      end
    end

    context 'when user total_points reach first milestone' do
      context 'for the first time' do
        before { allow(user).to receive(:total_points).and_return(first_milestone + 1) }

        it 'creates single user milestone record' do
          expect{ user.add_milestone }.to change { UserMilestone.count }
        end
      end

      context 'for the second time' do
        before do
          UserMilestone.create(user_id: user.id, milestone_id: milestones(:milestone_1).id)
          allow(user).to receive(:total_points).and_return(first_milestone + 51)
        end

        it 'does not create another user milestone record' do
          expect{ user.add_milestone }.not_to change { UserMilestone.count }
        end
      end
    end

    context 'when user total_points reach second milestone' do
      context 'for the first time' do
        before { allow(user).to receive(:total_points).and_return(second_milestone) }

        it 'creates single user milestone record' do
          expect{ user.add_milestone }.to change { UserMilestone.count }
        end
      end

      context 'for the second time' do
        before do
          UserMilestone.create(user_id: user.id, milestone_id: milestones(:milestone_2).id)
          allow(user).to receive(:total_points).and_return(second_milestone + 51)
        end

        it 'does not create another user milestone record' do
          expect{ user.add_milestone }.not_to change { UserMilestone.count }
        end
      end
    end
  end
end
