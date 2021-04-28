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

          expect(json_response[:message]).to eq 'Added 1 user to Test Project'
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

  describe '#destroy' do
    let(:user1) { users(:associate_one) }
    let(:user2) { users(:associate_two) }
    let(:project) { projects(:one) }

    before do
      project.users << [user1, user2]
    end

    subject(:remove_project_users_api) { put "/api/v1/projects/#{project.id}/users/remove", params: { user_ids: [1, 3] }, headers: { 'Authorization' => 'dummy' } }

    context 'when requested by member' do
      before { sign_in_as(users(:associate_one)) }

      it 'returns 403 status' do
        remove_project_users_api
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when requested by admin' do
      before { sign_in_as(users(:admin_one)) }

      it 'deletes requested users' do
        remove_project_users_api
        expect(project.users.reload.map(&:id)).not_to include(1)
      end
    end
  end
end
