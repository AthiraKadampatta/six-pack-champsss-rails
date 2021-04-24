class Api::V1::ProjectsController < ApplicationController
  # before_filter :require_admin

  api :POST, '/projects'
  param :name, String, desc: 'name of the project'

  def create
    @project = Project.create(project_params)

    if @project.persisted?
      render json: { message: 'Project created successfully!'}, status: :ok
    else
      render json: { message: @project.errors.full_messages }, status: 500
    end
  end

  private

  def project_params
    params.require(:project).permit(:name)
  end
end
