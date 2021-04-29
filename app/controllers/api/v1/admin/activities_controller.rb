class Api::V1::Admin::ActivitiesController < ApplicationController
  before_action :require_admin_or_owner
  before_action :set_activity, only: [:approve, :reject]

  api :PUT, '/v1/admin/activities/:id/approve', 'Approve an activity by admin'
  param :id, :number, required: true
  param :activity, Hash, desc: 'Activity info' do
    param :points_granted, :number, required: true
  end
  def approve
    return head :not_found unless @activity

    set_review_details_for_activity
    @activity.points_granted = params[:activity][:points_granted]

    if @activity.approve!
      render json: @activity, status: :ok
    else
      render json: @activity.errors, status: :unprocessable_entity
    end
  end

  api :PUT, '/v1/admin/activities/:id/reject', 'Reject an activity by admin'
  param :id, :number, required: true
  def reject
    return head :not_found unless @activity

    set_review_details_for_activity

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
    @activities = @activities.order(order_by_status)
  end

  private

  def set_activity
    @activity = Activity.find(params[:id])
  end

  def set_review_details_for_activity
    @activity.reviewed_by = current_user.id
    @activity.reviewed_at = Time.current
  end

  def order_by_status
    params[:status] == 'pending' ? 'created_at ASC' : 'updated_at DESC'
  end
end
