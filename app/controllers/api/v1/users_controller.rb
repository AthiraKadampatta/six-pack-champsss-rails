class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :assign_role, :destroy]
  before_action :require_admin_or_owner, only: [:assign_role, :destroy, :index]

  api :GET, '/v1/users/', 'All users List only for Admin'
  def index
    @users = User.all
    render json: @users, status: :ok
  end

  api :GET, '/v1/users/:id', 'User Profile Details'
  param :id, :number, desc: 'ID of the user', required: true
  def show; end

  api :PUT, '/v1/users/:id', 'Update user details for self'
  param :id, :number, desc: 'ID of the user', required: true
  param :user, Hash, desc: 'User info' do
    param :name, String, desc: 'user name'
  end

  def update
    head :forbidden and return if @user != current_user

    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  api :PUT, '/v1/users/:id/assign_role', 'Assign role to user by admin'
  param :id, :number, desc: 'ID of the user', required: true
  param :user, Hash, desc: 'User info' do
    param :role, String, desc: 'New role ID for the user', default: 'associate', required: true
  end

  def assign_role
    if @user.update(role: params[:user][:role])
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  api :DELETE, '/v1/users/:id', 'Destroy a user by admin'
  param :id, :number, desc: 'ID of the user', required: true

  def destroy
    if @user.destroy
      head :ok and return
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name)
  end
end
