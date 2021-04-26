json.project @project
json.users @project.users.each do |user|
  json.partial! 'api/v1/projects/user', user: user
end
