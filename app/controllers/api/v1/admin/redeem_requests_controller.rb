class Api::V1::Admin::RedeemRequestsController < ApplicationController
  before_action :require_admin_or_owner
  before_action :set_redeem_request, only: [:mark_complete]

  api :GET, '/v1/redeem_requests', 'List of all pending/completed redeem_requests'
  param :status, String, desc: 'status : pending or completed', required: true

  def index
    @redeem_requests = RedeemRequest.where(status: params[:status])
    @redeem_requests = @redeem_requests.order(order_by_status)
    render json: @redeem_requests
  end

  api :POST, '/v1/admin/redeem_requests/:id/mark_complete', 'Mark action as completed by admin'
  param :id, :number, required: true

  def mark_complete
    return head :not_found unless @redeem_request

    if @redeem_request.complete!
      render json: @redeem_request, status: :ok
    else
      render json: @redeem_request.errors, status: :unprocessable_entity
    end
  end


  private

  def set_redeem_request
    @redeem_request = RedeemRequest.find(params[:id])
  end

  def order_by_status
    params[:status] == 'pending' ? 'created_at ASC' : 'updated_at DESC'
  end
end
