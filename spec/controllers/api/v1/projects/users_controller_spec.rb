require 'rails_helper'

describe Api::V1::Projects::UsersController, type: :request do
  before { sign_in_as(users(:admin_one)) }

  describe '#create' do
    let(:user1) { users(:associate_one) }
    let(:user2) { users(:associate_two) }
    let(:project) { projects(:one) }

    it 'returns appropriate headers' do
      post "/api/v1/projects/#{project.id}/users", params: { user_ids: [1, 3] }, headers: { 'Authorization' => 'dummy' }
      expect(response.content_type).to include("application/json")
    end

    context 'with valid project id' do
      context 'with valid user ids' do
        it 'adds users to project' do
          expect {
            post "/api/v1/projects/#{project.id}/users", params: { user_ids: [1, 3] }, headers: { 'Authorization' => 'dummy' }
          }.to change { project.users.count }.by 2

          expect(response).to have_http_status(:success)
        end
      end

      context 'with 1 invalid user id' do
        it 'returns success with failed user details' do
          expect {
            post "/api/v1/projects/#{project.id}/users", params: { user_ids: [1, 4] }, headers: { 'Authorization' => 'dummy' }
          }.to change { project.users.count }.by 1

          expect(json_response[:message]).to eq 'Added 1 user to Test Project, Failed to add 1 user'
          expect(json_response[:failed_ids]).to eq ['4']
        end
      end
    end

    context 'with invalid project id' do
      it 'returns error' do
        post "/api/v1/projects/20/users", params: { user_ids: [1, 4] }, headers: { 'Authorization' => 'dummy' }

        expect(response.status).to eq 404
        expect(json_response[:error]).to eq 'Project Not Found'
      end
    end
  end
end
