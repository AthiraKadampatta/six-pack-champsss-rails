json.projects @projects.each do |project|
  json.partial! 'project', project: project
end
