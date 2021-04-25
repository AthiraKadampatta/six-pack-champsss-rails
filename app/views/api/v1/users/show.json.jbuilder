json.user @user
json.total_points do
  json.array! [{ project_name: "KFC", points: 100 }, { project_name: 'Hiring', points: 200 }]
end
json.available_points 150
json.redeemed_points 150