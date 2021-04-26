json.projects @projects.each do |project|
  json.id           project.id
  json.name         project.name
  json.total_points 400

  json.users project.users.each do |user|
    json.partial! 'api/v1/projects/user', user: user
  end
end
