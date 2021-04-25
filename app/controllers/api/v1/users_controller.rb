class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :assign_role, :destroy]
  before_action :require_admin, only: [:assign_role, :destroy]

  api :GET, '/v1/users/:id', 'User Profile Details'
  param :id, :number, desc: 'id of the user', required: true
  returns code: 200, desc: "Detailed info of the user" do
    property :user, Hash do
      property :id, Integer, desc: 'id of the requested user'
      property :name, String, desc: 'Name of the user'
      property :email, String, desc: 'Email of the user'
      property :role, String, desc: 'Role of the user'
      property :total_points, Hash, desc: 'Total points breakup based on projects' do
        property :project_name, String, desc: 'Name of the project'
        property :points, Integer, desc: 'Points claimed in the project'
      end
      property :available_points, Integer, desc: 'Balance points for a user'
      property :redeemed_points, Integer, desc: 'Total points redeemed till date across projects'
    end
  end
  def show; end

  api :PUT, '/v1/users/:id', 'Update user details for self'
  param :id, :number, desc: 'id of the user', required: true
  param :user, Hash, desc: 'User info' do
    param :name, String, desc: 'user name'
  end
  returns code: 200
  def update
    head :unauthorized and return if @user != current_user

    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  api :PUT, '/v1/users/:id/assign_role', 'Assign role to user by admin'
  param :id, :number, desc: 'id of the user', required: true
  param :user, Hash, desc: 'User info' do
    param :role, String, desc: 'New role id for the user', default: 'associate', required: true
  end
  returns code: 200
  def assign_role
    if @user.update(role: params[:user][:role])
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  api :DELETE, '/v1/users/:id', 'Destroy a user by admin'
  param :id, :number, desc: 'id of the user', required: true
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