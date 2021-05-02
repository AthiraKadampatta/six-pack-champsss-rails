require 'rails_helper'

describe Api::V1::Admin::ProjectsController, type: :request do
  before { sign_in_as(users(:admin_one)) }

  describe 'index' do
    subject(:all_projects) { get '/api/v1/admin/projects', headers: { 'Authorization' => 'dummy' } }

    context 'when requested by a non admin' do
      before { sign_in_as(users(:associate_one)) }

      it 'returns status 403' do
        all_projects

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'admin requests for all projects' do
      before { sign_in_as(users(:admin_one)) }
      
      it 'returns status 200' do
        all_projects

        expect(response).to have_http_status(:success)
      end
    end
  end

  describe '#update' do
    let(:project) { projects(:one) }
    subject(:update_project_api) { put "/api/v1/admin/projects/#{project.id}", params: { project: { name: 'ABC' } }, headers: { 'Authorization' => 'dummy' } }

    context 'when non-admin is logged in' do
      before { sign_in_as(users(:associate_one)) }

      it 'returns 403 status' do
        update_project_api
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when admin is logged in' do
      it 'returns 200 status' do
        update_project_api
        expect(response).to have_http_status(:success)
      end

      it 'updates the name' do
        update_project_api
        expect(project.reload.name).to eq 'ABC'
      end
    end
  end

  describe 'archive' do
    let(:project) { projects(:one) }

    subject(:archive_project_api) { put "/api/v1/admin/projects/#{project.id}/archive", headers: { 'Authorization' => 'dummy' } }

    context 'when admin is logged in' do
      it 'returns 200 status' do
        archive_project_api
        expect(response).to have_http_status(:success)
      end

      it 'archives the project' do
        expect { archive_project_api }.to change { Project.not_archived.count }.by -1
      end
    end

    context 'when associate is logged in' do
      before { sign_in_as(users(:associate_one)) }

      it 'returns 403 status' do
        archive_project_api
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe '#create' do
    it 'returns appropriate headers' do
      post "/api/v1/admin/projects", params: { project: { name: 'Test Project new' } }, headers: { 'Authorization' => 'dummy' }
      expect(response.content_type).to include("application/json")
    end

    context 'with valid params' do
      it 'creates new project' do
        expect {
          post "/api/v1/admin/projects", params: { project: { name: 'Test Project new' } }, headers: { 'Authorization' => 'dummy' }
        }.to change { Project.count }.by 1

        expect(response).to have_http_status(:success)
      end
    end

    context 'with invalid params' do
      it 'returns error' do
        expect {
          post "/api/v1/admin/projects", params: { project: { names: 'Invalid param' } }, headers: { 'Authorization' => 'dummy' }
        }.to change { Project.count }.by 0

        expect(json_response[:name]).to include 'can\'t be blank'
      end
    end

    it 'adds current user to the project' do
      post "/api/v1/admin/projects", params: { project: { name: 'Test Project new' } }, headers: { 'Authorization' => 'dummy' }
      expect(Project.last.users).to include(users(:admin_one))
    end
  end
end