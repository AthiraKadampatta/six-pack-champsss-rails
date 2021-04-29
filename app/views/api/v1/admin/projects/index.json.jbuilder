json.projects @projects.each do |project|
  json.partial! '/api/v1/projects/project', project: project
end
