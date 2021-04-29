class Api::V1::Admin::ProjectsController < ApplicationController
  before_action :require_admin_or_owner

  api :GET, '/v1/admin/projects', 'List of projects for user. List of all projects for admin'
  def index
    @projects = Project.all
  end
end