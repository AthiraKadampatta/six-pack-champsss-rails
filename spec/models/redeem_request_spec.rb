require "rails_helper"

RSpec.describe RedeemRequest, :type => :model do
  let(:user) { users(:associate_one) }

  before { allow(user).to receive(:available_points).and_return(100) }

  subject(:create_redeem_request) { RedeemRequest.create!(points: 100, user: user) }
  
  context 'when created' do
    it 'creates a debit transaction record' do
      expect { create_redeem_request }.to change { PointsTransaction.count }.by 1
    end

    it 'adds txn type as debit' do
      redeem_request = create_redeem_request
      expect(redeem_request.points_transaction.txn_type).to eq 'debit'
    end

    it 'adds points to be debited' do
      redeem_request = create_redeem_request
      expect(redeem_request.points_transaction.points).to eq(-100)
    end
  end

  context 'validation' do
    context 'when redeemed points are greater than available' do
      it 'throws validation error' do
        redeem_request = user.redeem_requests.create(points: 101)
        expect(redeem_request.errors.full_messages).to eq(["Points can't be greater than available_points"])
      end
    end
  end
end