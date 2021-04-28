class Api::V1::Admin::ActivitiesController < ApplicationController
  before_action :require_admin_or_owner
  before_action :set_activity, only: [:approve, :reject]

  api :POST, '/v1/admin/activities/:id/approve', 'Approve an activity by admin'
  param :id, :number, required: true
  param :activity, Hash, desc: 'Activity info' do
    param :points_granted, :number, required: true
  end
  def approve
    return head :not_found unless @activity

    if @activity.approve!
      render json: @activity, status: :ok
    else
      render json: @activity.errors, status: :unprocessable_entity
    end
  end

  api :POST, '/v1/admin/activities/:id/reject', 'Reject an activity by admin'
  param :id, :number, required: true
  def reject
    return head :not_found unless @activity

    if @activity.reject!
      render json: @activity, status: :ok
    else
      render json: @activity.errors, status: :unprocessable_entity
    end
  end

  api :GET, 'v1/admin/activities', 'Lists all activities of all users based on status'
  param :status, String, desc: 'status : pending, approved or rejected', required: true

  def index
    @activities = Activity.where(status: params[:status])
    @activities = params[:status] == 'pending' ? @activities.order('created_at ASC') : @activities.order('updated_at DESC')
    render json: @activities
  end

  private

  def set_activity
    @activity = Activity.find(params[:id])
  end
end
