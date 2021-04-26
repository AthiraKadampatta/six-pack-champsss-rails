json.user @user
json.points do
  json.total_points @user.total_points
  json.available_points @user.available_points
  json.redeemed_points @user.redeemed_points
  json.projects @user.points_per_project.each do |project_name, points|
    json.project_name project_name
    json.total_points points
  end
end

