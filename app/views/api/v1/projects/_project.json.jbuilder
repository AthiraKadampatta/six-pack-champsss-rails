json.id              project.id
json.name            project.name
json.points_per_hour project.points_per_hour
json.total_points project.users.inject(0) { |total, user| user.total_points }

json.users project.users.each do |user|
  json.partial! 'api/v1/projects/user', user: user
end
