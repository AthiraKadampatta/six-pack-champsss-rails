class Api::V1::RedeemRequestsController < ApplicationController

  api :POST, 'v1/redeem_requests', 'Creates a redeem request for current_user'
  param :redeem_request, Hash, desc: 'Redeem request info' do
    param :points, :number, desc: 'Points requested by the user', required: true
  end

  def create
    @redeem_request = @current_user.redeem_requests.create(redeem_request_params)
    if @redeem_request.persisted?
      render json: @redeem_request, status: :ok
    else
      render json: @redeem_request.errors, status: :unprocessable_entity
    end
  end

  private

  def redeem_request_params
    params.require(:redeem_requests).permit(:points)
  end
end