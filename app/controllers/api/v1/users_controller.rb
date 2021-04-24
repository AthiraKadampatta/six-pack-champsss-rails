class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :assign_role]
  before_action :require_admin, only: [:assign_role]

  api :GET, '/users/:id'
  returns code: 200, desc: "Detailed info of the user" do
    property :user, Hash do
      property :id, Integer, desc: 'id of the requested user'
      property :name, String, desc: 'Name of the user'
      property :email, String, desc: 'Email of the user'
      property :role, String, desc: 'Role id of the user'
    end
  end
  def show; end

  api :PUT, '/users/:id'
  param :user, Hash, desc: 'User info' do
    param :name, String, desc: 'user name'
  end
  returns code: 200
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  api :PUT, '/users/:id/:assign_role'
  param :user, Hash, desc: 'User info' do
    param :role, String, desc: 'New role id for the user'
  end
  returns code: 200
  def assign_role
    if @user.update(role: params[:user][:role])
      render json: @user
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

  def require_admin
    head :unauthorized unless (current_user.admin? || current_user.owner?)
  end
end