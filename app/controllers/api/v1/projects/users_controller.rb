class Api::V1::Projects::UsersController < ApplicationController
  # before_action :require_admin

  api :post, '/projects/:id/users'
  param :project_id, :number, desc: 'id of the project'
  param :user_ids, Array, desc: 'Array of user ids which we want to add to project'

  def create
    @project = Project.find_by_id(params[:project_id])

    if @project
      # to handle condition where from some user_ids
      # user record is not present in db,
      # so retrive user_ids from params
      # only if user is present in db
      user_ids = User.where(id: params[:user_ids]).pluck(:id)
      @project.user_ids = user_ids

      message =
        if (@failed_ids = params[:user_ids] - user_ids.map(&:to_s)).any?
          "Added #{user_ids.count} #{'user'.pluralize(user_ids.count)} to #{@project.name}, Failed to add #{@failed_ids.count} #{'user'.pluralize(@failed_ids.count)}"
        else
          "Added #{user_ids.count} users to #{@project.name}"
        end

      render json: { message: message, failed_ids:  @failed_ids }, status: 200
    else
      render json: { error: 'Project Not Found' }, status: 404
    end
  end
end
