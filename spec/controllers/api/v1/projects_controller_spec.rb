require 'rails_helper'

describe Api::V1::ProjectsController, type: :request do
  before { sign_in_as(users(:admin_one)) }

  describe '#create' do
    it 'returns appropriate headers' do
      post "/api/v1/projects", params: { project: { name: 'Test Project new' } }, headers: { 'Authorization' => 'dummy' }
      expect(response.content_type).to include("application/json")
    end

    context 'with valid params' do
      it 'creates new project' do
        expect {
          post "/api/v1/projects", params: { project: { name: 'Test Project new' } }, headers: { 'Authorization' => 'dummy' }
        }.to change { Project.count }.by 1

        expect(response).to have_http_status(:success)
      end
    end

    context 'with invalid params' do
      it 'returns error' do
        expect {
          post "/api/v1/projects", params: { project: { names: 'Invalid param' } }, headers: { 'Authorization' => 'dummy' }
        }.to change { Project.count }.by 0

        expect(json_response[:name]).to include 'can\'t be blank'
      end
    end
  end

  describe '#index' do
    let(:project) { projects :one }
    before do
      sign_in_as(users(:associate_one))
    end

    subject(:index_projects_api) { get "/api/v1/projects", headers: { 'Authorization' => 'dummy' } }

    it 'returns appropriate headers' do
      index_projects_api
      expect(response.content_type).to include("application/json")
    end

    it 'returns project users details' do
      associate_one = users(:associate_one)
      associate_two = users(:associate_two)

      project.users << [associate_one, associate_two]

      index_projects_api

      expect(json_response[:projects].map { |p| p[:users].map{ |u| u[:name] } }).to match_array([
        [associate_one.name,
        associate_two.name]
      ])
    end

    context 'for any user' do
      let(:associate_one) { users :associate_one }
      let(:associate_two) { users :associate_two }

      before do
        project.user_ids = [associate_one.id]
      end

      it 'returns user\'s projects' do
        index_projects_api

        expect(json_response[:projects].map { |p| p[:id] }.compact).to match_array([1])
      end
    end
  end

  describe '#show' do
    let(:project) { projects :one }

    subject(:show_project_api) { get "/api/v1/projects/#{project.id}", headers: { 'Authorization' => 'dummy' } }

    it 'returns appropriate headers' do
      show_project_api
      expect(response.content_type).to include("application/json")
    end

    it 'returns project details' do
      show_project_api

      expect(response).to have_http_status(:success)
      expect(json_response[:name]).to eq project.name
    end

    it 'reutrns project users details' do
      associate_one = users(:associate_one)
      associate_two = users(:associate_two)

      project.user_ids = [associate_one.id, associate_two.id]

      show_project_api

      expect(json_response[:users].map{ |u| u[:name] }).to match_array([
        associate_one.name,
        associate_two.name
      ])
    end

    context 'for non-admin user' do
      let(:associate_one) { users :associate_one }
      let(:associate_two) { users :associate_two }

      before { sign_in_as(users(:associate_one)) }

      context 'current user present in requested project' do
        before { project.user_ids = [associate_one.id] }

        it 'returns user\'s project' do
          show_project_api

          expect(json_response[:name]).to eq project.name
        end
      end

      context 'current user not present in requested project' do
        it 'returns user\'s project' do
          show_project_api

          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  describe '#update' do
    let(:project) { projects(:one) }
    subject(:update_project_api) { put "/api/v1/projects/#{project.id}", params: { project: { name: 'ABC' } }, headers: { 'Authorization' => 'dummy' } }

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

  describe 'destroy' do
    let(:project) { projects(:one) }

    subject(:destroy_project_api) { delete "/api/v1/projects/#{project.id}", headers: { 'Authorization' => 'dummy' } }

    context 'when admin is logged in' do
      it 'returns 200 status' do
        destroy_project_api
        expect(response).to have_http_status(:success)
      end

      it 'destroys the project' do
        expect { destroy_project_api }.to change { Project.count }.by -1
      end
    end

    context 'when associate is logged in' do
      before { sign_in_as(users(:associate_one)) }

      it 'returns 403 status' do
        destroy_project_api
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
