require 'rails_helper'

describe Api::V1::Admin::RedeemRequestsController, type: :request do
  describe 'mark complete' do
    let(:redeem_request) { redeem_requests(:redeem_pending) }

    subject(:mark_complete_request) {
      put "/api/v1/admin/redeem_requests/#{redeem_request.id}/mark_complete",
        headers: { 'Authorization' => 'dummy' }
    }

    context 'when non-admin is logged in' do
      before { sign_in_as(users(:associate_one)) }

      it 'returns 403' do
        mark_complete_request
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when admin is logged in' do
      before { sign_in_as(users(:admin_one)) }

      it 'returns 200' do
        mark_complete_request
        expect(response).to have_http_status(:success)
      end

      it 'changes state of redeem_request to completed' do
        mark_complete_request
        expect(redeem_request.reload.completed?).to be true
      end
    end
  end

  describe 'index' do
    before { sign_in_as(users(:admin_one)) }

    subject(:all_redeem_requests) { get '/api/v1/admin/redeem_requests',
      params: {status: status}, headers: { 'Authorization' => 'dummy' } }

    context 'when requested by a non admin' do
      before { sign_in_as(users(:associate_one)) }

      it 'returns status 403' do
        all_redeem_requests

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'admin requests for all pending redeem_requests' do
      let(:status) { 'pending' }

      it 'returns status 200' do
        all_redeem_requests

        expect(response).to have_http_status(:success)
      end

      it 'returns user_name' do
        all_redeem_requests

        expect(json_response.first.keys).to eql [:id, :user_id, :points, :status, :reward_id, :created_at, :updated_at, :user_name]
      end

      it 'returns only pending requests' do
        all_redeem_requests

        expect(json_response.first.values).to include('pending')
        expect(json_response.first.values).not_to include('completed')
      end
    end

    context 'admin requests for all completed redeem_requests' do
      let(:status) { 'completed' }

      it 'returns status 200' do
        all_redeem_requests

        expect(response).to have_http_status(:success)
      end

      it 'returns only completed requests' do
        all_redeem_requests

        expect(json_response.first.values).not_to include('pending')
        expect(json_response.first.values).to include('completed')
      end
    end
  end
end
