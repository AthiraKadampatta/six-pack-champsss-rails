class Api::V1::Projects::UsersController < ApplicationController
  before_action :require_admin_or_owner
  before_action :set_project

  api :POST, '/v1/projects/:id/users', 'Add list of users to project'
  param :project_id, :number, desc: 'ID of the project'
  param :user_ids, Array, desc: 'Array of user ids which we want to add to project'

  def create
    if @project
      # to handle condition where from some user_ids
      # user record is not present in db,
      # so retrive user_ids from params
      # only if user is present in db
      users = User.where(id: params[:user_ids])
      users_to_add = users - @project.users
      user_ids = users_to_add.pluck(:id)
      @project.users << users_to_add

      message = "Added #{user_ids.count} #{'user'.pluralize(user_ids.count)} to #{@project.name}"
      @failed_ids = params[:user_ids] - user_ids.map(&:to_s)

      render json: { message: message, failed_ids:  @failed_ids }, status: 200
    else
      render json: { error: 'Project Not Found' }, status: 404
    end
  end

  api :PUT, '/v1/projects/:id/users/remove', 'REMOVE list of users from project'
  param :project_id, :number, desc: 'ID of the project'
  param :user_ids, Array, desc: 'Array of user ids which we want to remove from project'

  def remove
    return head :not_found unless @project

    users = User.where(id: params[:user_ids])
    if @project.users.delete(users)
      head :ok and return
    else
      head :unprocessable_entity and return
    end
  end

  private

  def set_project
    @project = Project.find_by_id(params[:project_id])
  end
end
