class Api::V1::ProjectsController < ApplicationController

  api :GET, '/v1/projects', 'List of projects for user.'
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
    @projects = current_user.projects

    render 'index'
  end

  # Project list with users & points (show and index (include users))
  # && Make project level breakdown of points in user response dynamic

  api :GET, '/v1/projects/:id', 'Details of project'
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

    return head :not_found unless @project
  end
end
