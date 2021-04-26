require 'rails_helper'

describe Api::V1::Admin::ActivitiesController, type: :request do
  describe 'approve' do
    let(:activity) { activities(:activity_1) }

    subject(:approve_request) {
      put "/api/v1/admin/activities/#{activity.id}/approve",
        params: { activity: { points_granted: 200 } },
        headers: { 'Authorization' => 'dummy' }
    }

    context 'when non-admin is logged in' do
      before { sign_in_as(users(:associate_one)) }

      it 'returns 401' do
        approve_request
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when admin is logged in' do
      before { sign_in_as(users(:admin_one)) }

      it 'returns 200' do
        approve_request
        expect(response).to have_http_status(:success)
      end

      it 'changes state of activity to approved' do
        approve_request
        expect(activity.reload.approved?).to be true
      end
    end
  end

  describe 'reject' do
    let(:activity) { activities(:activity_1) }
    subject(:reject_request) {
      put "/api/v1/admin/activities/#{activity.id}/reject", headers: { 'Authorization' => 'dummy' }
    }

    context 'when non-admin is logged in' do
      before { sign_in_as(users(:associate_one)) }

      it 'returns 401' do
        reject_request
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when admin is logged in' do
      before { sign_in_as(users(:admin_one)) }

      it 'returns 200' do
        reject_request
        expect(response).to have_http_status(:success)
      end

      it 'changes state of activity to rejected' do
        reject_request
        expect(activity.reload.rejected?).to be true
      end
    end
  end
end