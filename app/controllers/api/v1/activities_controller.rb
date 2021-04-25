class Api::V1::ActivitiesController < ApplicationController
  before_action :set_activity, only: [:update, :destroy]
  before_action :require_admin, only: [:admin_index]

  api :GET, 'v1/activities', 'Lists all the activities of a user'
  param :status, String, desc: 'pending, approved or rejected', required: false

  def index
    @activities = @current_user.activities
    @activities = @activities.where(status: params[:status]) if params[:status]
    render json: @activities
  end

  api :POST, '/v1/activities', 'Creates a user activity'
  param :activity, Hash, desc: 'Activity info' do
    param :description, String, desc: 'Description of the activity', required: true
    param :duration, :number, desc: 'Activity duration in minutes', required: true
    param :project_id, :number, desc: 'ID of the project', required: true
    param :points_requested, :number, desc: 'Points requested by the user', required: true
    param :performed_on, Date, desc: 'Date on which the activity is performed', required: true
  end

  def create
    @activity = @current_user.activities.create(activity_params)
    if @activity.persisted?
      render json: @activity, status: :ok
    else
      render json: @activity.errors, status: :unprocessable_entity
    end
  end

  api :PUT, '/v1/activities/:id', 'Updates "pending" activity only'
  param :id, :number, required: true
  param :activity, Hash, desc: 'Activity info' do
    param :description, String, required: true
    param :duration, :number, desc: 'Activity duration in minutes', required: true
    param :project_id, :number, required: true
    param :points_requested, :number, desc: 'Points requested by the user', required: true
    param :performed_on, Date, required: true
  end

  def update
    return head :not_found unless @activity

    if @activity.update(activity_params)
      render json: @activity, status: :ok
    else
      render json: @activity.errors, status: :unprocessable_entity
    end
  end

  api :DELETE, '/v1/activities/:id', 'Deletes "pending" activity only'
  param :id, :number, required: true

  def destroy
    return head :not_found unless @activity

    @activity.destroy
    head :ok
  end

  api :GET, 'v1/activities/all', 'Lists all activities of all users based on status'
  param :status, String, required: true

  def admin_index
    @activities = Activity.where(status: params[:status])
    render json: @activities
  end

  private

  def activity_params
    params.require(:activity).permit(
      :description,
      :duration,
      :project_id,
      :points_requested,
      :performed_on
    )
  end

  def set_activity
    @activity = @current_user.activities.find_by(id: params[:id])
  end
end
