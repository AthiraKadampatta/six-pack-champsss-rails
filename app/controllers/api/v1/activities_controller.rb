class Api::V1::ActivitiesController < ApplicationController
  before_action :set_activity, only: [:update, :destroy]

  def index
    @activities = @current_user.activities.where(status: params[:status])
    render json: @activities
  end

  def create
    @activity = @current_user.activities.create(activity_params)
    if @activity.persisted?
      render json: @activity, status: :ok
    else
      render json: @activity.errors, status: :unprocessable_entity
    end
  end

  def update
    return head :not_found unless @activity

    if @activity.update(activity_params)
      render json: @activity, status: :ok
    else
      render json: @activity.errors, status: :unprocessable_entity
    end
  end

  def destroy
    return head :not_found unless @activity

    @activity.destroy
    head :ok
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
