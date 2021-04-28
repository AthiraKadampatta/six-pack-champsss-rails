class Api::V1::ProjectsController < ApplicationController
  before_action :require_admin_or_owner, only: [:create, :update, :destroy]
  before_action :set_project, only: [:destroy, :update]

  api :POST, '/v1/projects', desc: 'Create a new project by admin'
  param :name, String, desc: 'name of the project'

  def create
    @project = Project.create(project_params)

    if @project.persisted?
      render json: { message: 'Project created successfully!'}, status: :ok
    else
      render json: { message: @project.errors }, status: :unprocessable_entity
    end
  end

  api :PUT, '/v1/projects/:id', desc: 'Update project details by admin'
  param :id, :number, desc: 'ID of the project to be updated'
  param :name, String, desc: 'name of the project'

  def update
    return head :not_found unless @project

    if @project.update(project_params)
      render json: { message: 'Project updated successfully!'}, status: :ok
    else
      render json: { message: @project.errors }, status: :unprocessable_entity
    end
  end

  api :GET, '/v1/projects', desc: 'List of projects for user. List of all projects for admin'
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
      if current_user.admin_or_owner?
        Project.all
      else
        current_user.projects
      end

    render 'index'
  end

  # Project list with users & points (show and index (include users))
  # && Make project level breakdown of points in user response dynamic

  api :GET, '/v1/projects/:id', desc: 'Details of project'
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
      if current_user.admin_or_owner?
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

  api :DELETE, '/v1/projects/:id', desc: 'Delete a project by admin'
  param :id, :number, desc: 'ID of the project to be deleted'

  def destroy
    return head :not_found unless @project

    if @project.destroy
      render json: { message: 'Project deleted successfully!'}, status: :ok
    else
      render json: { message: @project.errors }, status: :unprocessable_entity
    end
  end

  private

  def project_params
    params.require(:project).permit(:name, :points_per_hour)
  end

  def set_project
    @project ||= Project.find(params[:id])
  end
end
