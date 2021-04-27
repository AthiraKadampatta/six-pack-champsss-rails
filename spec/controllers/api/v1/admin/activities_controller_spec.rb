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

      it 'returns 403' do
        approve_request
        expect(response).to have_http_status(:forbidden)
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

      it 'updates points_granted' do
        approve_request
        expect(activity.reload.points_granted).to eq 200
      end

      it 'updates reviewer details' do
        approve_request
        expect(activity.reload.reviewed_by).to eq(users(:admin_one).id)
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

      it 'returns 403' do
        reject_request
        expect(response).to have_http_status(:forbidden)
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

      it 'updates reviewer details' do
        reject_request
        expect(activity.reload.reviewed_by).to eq(users(:admin_one).id)
      end
    end
  end

  describe 'index' do
    before { sign_in_as(users(:admin_one)) }

    let(:pending_activities) { Activity.pending.to_json }
    let(:approved_activities) { Activity.approved.to_json }
    let(:rejected_activities) { Activity.rejected.to_json }

    subject(:admin_index_request) { get '/api/v1/admin/activities',
      params: {status: status}, headers: { 'Authorization' => 'dummy' } }

    context 'when requested by a non admin' do
      before { sign_in_as(users(:associate_one)) }

      it 'returns status 403' do
        admin_index_request

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'admin requests for all pending activities' do
      let(:status) { 'pending' }

      it 'returns status 200' do
        admin_index_request

        expect(response).to have_http_status(:success)
        expect(json_response.to_json).to eql pending_activities
      end
    end

    context 'admin requests for all approved activities' do
      let(:status) { 'approved' }

      it 'returns status 200' do
        admin_index_request

        expect(response).to have_http_status(:success)
        expect(json_response.to_json).to eql approved_activities
      end
    end

    context 'admin requests for all rejected activities' do
      let(:status) { 'rejected' }

      it 'returns status 200' do
        admin_index_request

        expect(response).to have_http_status(:success)
        expect(json_response.to_json).to eql rejected_activities
      end
    end
  end
end
