class CreateActivities < ActiveRecord::Migration[6.1]
  def change
    create_table :activities do |t|
      t.text     :description
      t.integer  :duration
      t.integer  :project_id
      t.integer  :user_id
      t.integer  :points_requested
      t.datetime :performed_on

      t.timestamps
    end

    add_index :activities, :user_id
    add_index :activities, :project_id
  end
end
