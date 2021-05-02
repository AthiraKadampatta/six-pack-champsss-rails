class Api::V1::Admin::ProjectsController < ApplicationController
  before_action :require_admin_or_owner
  before_action :set_project, only: [:archive, :update]

  api :GET, '/v1/admin/projects', 'List of projects for user. List of all projects for admin'
  def index
    @projects = Project.not_archived.all
  end

  api :POST, '/v1/admin/projects', 'Create a new project by admin'
  param :name, String, desc: 'name of the project'

  def create
    @project = Project.create(project_params)

    if @project.persisted?
      @project.users << current_user
      render json: @project, status: :ok
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  api :PUT, '/v1/admin/projects/:id', 'Update project details by admin'
  param :id, :number, desc: 'ID of the project to be updated'
  param :name, String, desc: 'name of the project'

  def update
    return head :not_found unless @project

    if @project.update(project_params)
      render json: @project, status: :ok
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  api :PUT, '/v1/admin/projects/:id/archive', 'Archive a project by admin'
  param :id, :number, desc: 'ID of the project to be archived'

  def archive
    return head :not_found unless @project

    @project.archive
    head :ok
  end

  private

  def project_params
    params.require(:project).permit(:name, :points_per_hour)
  end

  def set_project
    @project ||= Project.find(params[:id])
  end
end