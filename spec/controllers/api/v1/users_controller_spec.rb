require 'rails_helper'

describe Api::V1::UsersController, type: :request do
  before { sign_in_as(users(:associate_one)) }

  describe 'index' do
    subject(:index_users_api) { get "/api/v1/users/", headers: { 'Authorization' => 'dummy' } }

    it 'returns all users' do
      index_users_api
      expect(json_response.size).to eq User.count
    end
  end

  describe 'show' do
    let(:user) { users(:associate_one) }
    subject(:show_users_api) { get "/api/v1/users/#{user.id}", headers: { 'Authorization' => 'dummy' } }

    it 'returns appropriate headers' do
      show_users_api
      expect(response.content_type).to include("application/json")
    end

    it 'has user and total points in response' do
      show_users_api
      expect(json_response.keys).to include(:user, :points)
    end

    it 'has required keys in user' do
      show_users_api
      expect(json_response[:user].keys).to include(:id, :name, :token, :email, :role)
    end

    it 'has required keys in points' do
      show_users_api
      expect(json_response[:points].keys).to include(:total_points, :available_points, :redeemed_points, :projects)
    end
  end

  describe 'update' do
    let(:user) { users(:associate_one) }
    subject(:update_user_api) { put "/api/v1/users/#{user.id}", params: { user: { name: 'ABC' } }, headers: { 'Authorization' => 'dummy' } }

    context 'when current user and passed user is same' do
      it 'returns 200 status' do
        update_user_api
        expect(response).to have_http_status(:success)
      end

      it 'updates the name' do
        update_user_api
        expect(user.reload.name).to eq 'ABC'
      end
    end

    context 'when current user and passed user are different' do
      before { sign_in_as(users(:admin_one)) }

      it 'returns 403 status' do
        update_user_api
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'assign_role' do
    let(:user) { users(:associate_one) }
    subject(:assign_role_api) { put "/api/v1/users/#{user.id}/assign_role", params: { user: { role: 'admin' } }, headers: { 'Authorization' => 'dummy' } }

    context 'when admin is logged in' do
      before { sign_in_as(users(:admin_one)) }

      it 'returns 200 status' do
        assign_role_api
        expect(response).to have_http_status(:success)
      end

      it 'updates the role' do
        assign_role_api
        expect(user.reload.admin?).to be true
      end
    end

    context 'when associate is logged in' do
      before { sign_in_as(users(:associate_one)) }

      it 'returns 403 status' do
        assign_role_api
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'destroy' do
    let(:user) { users(:associate_one) }

    subject(:destroy_api) { delete "/api/v1/users/#{user.id}", headers: { 'Authorization' => 'dummy' } }

    context 'when admin is logged in' do
      before { sign_in_as(users(:admin_one)) }

      it 'returns 200 status' do
        destroy_api
        expect(response).to have_http_status(:success)
      end

      it 'destroys the user' do
        expect { destroy_api }.to change { User.count }.by -1
      end
    end

    context 'when associate is logged in' do
      before { sign_in_as(users(:associate_one)) }

      it 'returns 403 status' do
        destroy_api
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
