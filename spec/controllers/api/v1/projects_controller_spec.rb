require 'rails_helper'

describe Api::V1::ProjectsController, type: :request do
  before { sign_in_as(users(:admin_one)) }

  describe '#create' do
    it 'returns appropriate headers' do
      post "/api/v1/projects", params: { project: { name: 'Test Project' } }, headers: { 'Authorization' => 'dummy' }
      expect(response.content_type).to include("application/json")
    end

    context 'with valid params' do
      it 'creates new project' do
        expect {
          post "/api/v1/projects", params: { project: { name: 'Test Project' } }, headers: { 'Authorization' => 'dummy' }
        }.to change { Project.count }.by 1

        expect(response).to have_http_status(:success)
        expect(json_response[:message]).to eq 'Project created successfully!'
      end
    end

    context 'with invalid params' do
      it 'returns error' do
        expect {
          post "/api/v1/projects", params: { project: { names: 'Invalid param' } }, headers: { 'Authorization' => 'dummy' }
        }.to change { Project.count }.by 0

        expect(json_response[:message][:name]).to include 'can\'t be blank'
      end
    end
  end

  describe '#index' do
    let(:project) { projects :one }

    subject(:index_projects_api) { get "/api/v1/projects", headers: { 'Authorization' => 'dummy' } }

    it 'returns appropriate headers' do
      index_projects_api
      expect(response.content_type).to include("application/json")
    end

    it 'returns all projects' do
      index_projects_api

      expect(response).to have_http_status(:success)
      expect(json_response[:projects].map { |p| p[:id] }).to match_array([1, 2])
    end

    it 'reutrns project users details' do
      associate_one = users(:associate_one)
      associate_two = users(:associate_two)

      project.user_ids = [associate_one.id, associate_two.id]

      index_projects_api

      expect(json_response[:projects].map { |p| p[:users].map{ |u| u[:name] } }).to match_array([
        [],
        [associate_one.name,
        associate_two.name]
      ])
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
      expect(json_response[:project][:name]).to eq project.name
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
  end
end
