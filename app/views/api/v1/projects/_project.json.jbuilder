project_users = @current_user.admin? ? project.users : [@current_user]

json.id           project.id
json.name         project.name
json.total_points project_users.inject(0) { |total, user| user.total_points }

json.users project_users.each do |user|
  json.partial! 'api/v1/projects/user', user: user
end
