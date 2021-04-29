require "rails_helper"

RSpec.describe Activity, :type => :model do
  let(:activity) { activities(:activity_5) }

  context 'when state changes' do
    context 'pending to approved' do
      it 'creates a credit transaction record' do
        expect { activity.approve }.to change { PointsTransaction.count }.by 1
      end

      it 'adds txn type as credit' do
        activity.approve
        expect(activity.points_transaction.txn_type).to eq 'credit'
      end

      it 'adds points granted as points' do
        activity.approve
        expect(activity.points_transaction.points).to eq 70
      end

      it 'calls add_milestone on user' do
        expect(activity.user).to receive(:add_milestone)
        activity.approve
      end
    end

    context 'pending to rejected' do
      it 'does not create a transaction record' do
        expect { activity.reject }.not_to change { PointsTransaction.count }
      end
    end
  end
end