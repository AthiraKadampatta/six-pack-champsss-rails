class CreatePointsRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :points_requests do |t|
      t.integer :activity_id
      t.integer :status
      t.integer :points_granted
      t.integer :action_by

      t.timestamps
    end
  end
end
