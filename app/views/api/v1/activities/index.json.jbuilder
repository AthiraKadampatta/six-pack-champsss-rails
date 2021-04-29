json.array! @activities do |activity|
  json.extract! activity, :id, :description, :duration, :project_id, :user_id, :points_requested, :performed_on, :status, :points_granted, :reviewed_by, :reviewed_at, :created_at, :updated_at
  json.user_name activity.user.name
end