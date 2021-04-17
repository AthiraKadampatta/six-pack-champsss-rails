class Api::V1::UsersController < ApplicationController
  
  api :GET, '/users/:id'
  param :id, :number, desc: 'id of the requested user'

  def show
    @user = User.find_by_id(params[:id])
  end
end