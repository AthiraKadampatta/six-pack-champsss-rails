require 'rails_helper'

describe Api::V1::UsersController, type: :request do
  describe 'show' do
    let(:user) { users(:one) }
    subject(:show_users_api) { get "/api/v1/users/#{user.id}" }

    it 'returns appropriate headers' do
      show_users_api
      expect(response.content_type).to include("application/json")
    end

    it 'has user and total points in response' do
      show_users_api
      expect(json_response.keys).to include(:user, :total_points)
    end

    it 'has required keys in user' do
      show_users_api
      expect(json_response[:user].keys).to include(:id, :name, :token, :email, :role_id)
    end

    it 'has required keys in total_points' do
      show_users_api
      expect(json_response[:total_points].map(&:keys).flatten.uniq).to include(:project_name, :points)
    end
  end
end