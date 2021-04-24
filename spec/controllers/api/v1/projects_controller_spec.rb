require 'rails_helper'

describe Api::V1::ProjectsController, type: :request do
  describe '#create' do
    it 'returns appropriate headers' do
      post "/api/v1/projects", params: { project: { name: 'Test Project' } }
      expect(response.content_type).to include("application/json")
    end

    context 'with valid params' do
      it 'creates new project' do
        expect {
          post "/api/v1/projects", params: { project: { name: 'Test Project' } }
        }.to change { Project.count }.by 1

        expect(response).to have_http_status(:success)
        expect(json_response[:message]).to eq 'Project created successfully!'
      end
    end

    context 'with invalid params' do
      it 'returns error' do
        expect {
          post "/api/v1/projects", params: { project: { names: 'Invalid param' } }
        }.to change { Project.count }.by 0

        expect(json_response[:message]).to include 'Name can\'t be blank'
      end
    end
  end
end
