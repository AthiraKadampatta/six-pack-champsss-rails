require 'rails_helper'

describe Api::V1::ActivitiesController, type: :request do
  before { sign_in_as(users(:associate_one)) }

  describe 'index' do
    let(:user_1) { users(:associate_one) }

    subject(:index_request) {
      get '/api/v1/activities', params: { status: status },
          headers: { 'Authorization' => 'dummy' }
    }

    context 'when requested for pending activities' do
      let(:status) { "pending" }

      it 'returns status 200' do
        index_request

        expect(response).to have_http_status(:success)
        expect(json_response.map { |x| x[:status] }).to  include('pending')
        expect(json_response.map { |x| x[:status] }).not_to  include('approved')
      end
    end

    context 'when requested for approved activities' do
      let(:status) { "approved" }

      it 'returns status 200' do
        index_request

        expect(response).to have_http_status(:success)
        expect(json_response.map { |x| x[:status] }).to include('approved')
        expect(json_response.map { |x| x[:status] }).not_to include('pending')
      end
    end

    context 'when requested for rejected activities' do
      let(:status) { "rejected" }

      it 'returns status 200' do
        index_request

        expect(response).to have_http_status(:success)
        expect(json_response.map { |x| x[:status] }).to include('rejected')
        expect(json_response.map { |x| x[:status] }).not_to include('approved')
      end
    end
  end

  describe 'create' do
    let(:user_1) { users(:associate_one) }

    it 'returns status 200 if record is created sucessfully' do
      post '/api/v1/activities',
        params: {
          activity: {
            user_id: user_1.id, project_id: 1, description: 'Some activity',
            duration: 1000,
            points_requested: 50
          }
        }, headers: { 'Authorization' => 'dummy' }

      expect(response).to have_http_status(:success)
    end
  end

  describe 'update' do
    let(:user_1) { users(:associate_one) }
    let(:activity) { user_1.activities.first }
    let(:activity_2) { users(:associate_two).activities.first }

    subject(:update_request) {
      put "/api/v1/activities/#{activity.id}",
        params: { activity: { points_requested: 200, duration: 5000 } },
        headers: { 'Authorization' => 'dummy' }
    }

    context 'when activity belongs to the user' do
      it 'returns status 200' do
        update_request

        expect(response).to have_http_status(:success)
        expect(activity.reload.points_requested).to eql 200
        expect(activity.reload.duration).to eql 5000
      end
    end

    context 'when activity does not belong to the user' do
      before { sign_in_as(users(:associate_two)) }

      it 'returns status 404' do
        update_request

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'destroy' do
    let(:user_1) { users(:associate_one) }
    let(:activity) { user_1.activities.first }

    subject(:delete_request) { delete "/api/v1/activities/#{activity.id}",
      headers: { 'Authorization' => 'dummy' } }

    context 'when activity belongs to the user' do
      it 'returns status 200' do
        delete_request

        expect(response).to have_http_status(:success)
      end
    end

    context 'when activity does not belong to the user' do
      before { sign_in_as(users(:associate_two)) }

      it 'returns status 404' do
        delete_request

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
