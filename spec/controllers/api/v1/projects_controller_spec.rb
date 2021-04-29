require 'rails_helper'

describe Api::V1::ProjectsController, type: :request do
  before { sign_in_as(users(:admin_one)) }

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
end
