require 'rails_helper'

describe Api::V1::Admin::ProjectsController, type: :request do
    describe 'index' do
    before { sign_in_as(users(:admin_one)) }

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
end