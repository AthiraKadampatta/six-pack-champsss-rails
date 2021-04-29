json.array! @redeem_requests do |redeem_request|
  json.extract! redeem_request, :id, :user_id, :points, :status, :reward_id, :created_at, :updated_at
  json.user_name redeem_request.user.name
end