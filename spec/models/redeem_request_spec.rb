require "rails_helper"

RSpec.describe RedeemRequest, :type => :model do
  subject(:create_redeem_request) { RedeemRequest.create!(points: 100, user_id: 1) }
  
  context 'when created' do
    it 'creates a debit transaction record' do
      expect { create_redeem_request }.to change { PointsTransaction }.by 1
    end

    it 'adds txn type as debit' do
      redeem_request = create_redeem_request
      expect(redeem_request.points_transaction.txn_type).to eq 'debit'
    end

    it 'adds points to be debited' do
      redeem_request = create_redeem_request
      expect(redeem_request.points_transaction.points).to eq 100
    end
  end
end