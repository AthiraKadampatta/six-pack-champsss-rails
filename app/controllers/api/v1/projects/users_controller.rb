class Api::V1::Projects::UsersController < ApplicationController
  before_action :require_admin_or_owner
  before_action :set_project

  api :POST, '/v1/projects/:id/users', 'Add list of users to project'
  param :project_id, :number, desc: 'ID of the project'
  param :user_ids, Array, desc: 'Array of user ids which we want to add to project'

  def create
    return head :not_found unless @project

    set_users
    @project.users << @users

    render json: { failed_ids:  @failed_ids }, status: :ok
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

  def set_users
    # to handle condition where from some user_ids
    # user record is not present in db,
    # so retrive user_ids from params
    # only if user is present in db
    users = User.where(id: params[:user_ids])

    # remove users which are already present on project
    @users = users - @project.users
    @failed_ids = params[:user_ids] - @users.pluck(:id).map(&:to_s)
  end

  def set_project
    @project = Project.find_by_id(params[:project_id])
  end
end
