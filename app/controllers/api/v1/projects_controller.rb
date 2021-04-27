class Api::V1::ProjectsController < ApplicationController
  before_action :require_admin, only: :create

  api :POST, '/v1/projects'
  param :name, String, desc: 'name of the project'

  def create
    @project = Project.create(project_params)

    if @project.persisted?
      render json: { message: 'Project created successfully!'}, status: :ok
    else
      render json: { message: @project.errors }, status: :unprocessable_entity
    end
  end

  api :GET, '/v1/projects'
  returns code: 200, desc: "All projects with users" do
    property :projects, array_of: Hash do
      property :name, String, desc: 'Name of project'
      property :total_points, Integer, desc: 'Total points for project'
      property :users, array_of: Hash do
        property :id, Integer, desc: 'id of the requested user'
        property :name, String, desc: 'Name of the user'
        property :email, String, desc: 'Email of the user'
        property :total_points, Integer, desc: 'Total points breakup based on projects'
        property :available_points, Integer, desc: 'Balance points for a user'
        property :redeemed_points, Integer, desc: 'Total points redeemed till date across projects'
      end
    end
  end

  def index
    @projects =
      if current_user.admin?
        Project.all
      else
        current_user.projects
      end

    render 'index'
  end

  # Project list with users & points (show and index (include users))
  # && Make project level breakdown of points in user response dynamic

  api :GET, '/v1/projects/:id'
  param :id, :number, desc: 'id of requested project'
  returns code: 200, desc: "Detailed info of the user" do
    property :projects, Hash, desc: 'Hash of projects' do
      property :name, String, desc: 'Name of project'
      property :total_points, Integer, desc: 'Total points for project'
      property :users, array_of: Hash do
        property :id, Integer, desc: 'id of the requested user'
        property :name, String, desc: 'Name of the user'
        property :email, String, desc: 'Email of the user'
        property :role, String, desc: 'Role of the user'
        property :total_points, Integer, desc: 'Total points breakup based on projects'
        property :available_points, Integer, desc: 'Balance points for a user'
        property :redeemed_points, Integer, desc: 'Total points redeemed till date across projects'
      end
    end
  end

  def show
    @project =
      if current_user.admin?
        Project.find(params[:id])
      else
        current_user.projects.where(id: params[:id]).first
      end

    if @project
      render 'show'
    else
      render json: { error: 'Not found' }, status: :not_found
    end
  end

  private

  def project_params
    params.require(:project).permit(:name)
  end
end
