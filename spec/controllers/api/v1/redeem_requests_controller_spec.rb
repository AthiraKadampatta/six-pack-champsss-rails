require 'rails_helper'

describe Api::V1::RedeemRequestsController, type: :request do
  before { sign_in_as(users(:associate_one)) }

  describe 'create' do
    let(:user) { users(:associate_one) }
    before { allow_any_instance_of(User).to receive(:available_points).and_return(200) }
    subject(:create_redeem_request) { post "/api/v1/redeem_requests", params: { redeem_request: { points: 100 } }, headers: { 'Authorization' => 'dummy' } }

    it 'returns 200 status' do
      create_redeem_request
      expect(response).to have_http_status(:success)
    end

    it 'updates the name' do
      expect { create_redeem_request }.to change { RedeemRequest.count }.by 1
    end
  end
end
