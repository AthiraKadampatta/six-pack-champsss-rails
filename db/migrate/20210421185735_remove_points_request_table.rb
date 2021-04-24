class RemovePointsRequestTable < ActiveRecord::Migration[6.1]
  def change
    drop_table :points_requests
  end
end
