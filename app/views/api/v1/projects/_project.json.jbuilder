project_users = @current_user.admin? ? project.users : [@current_user]

json.id           project.id
json.name         project.name
json.total_points 400

json.users project_users.each do |user|
  json.partial! 'api/v1/projects/user', user: user
end
