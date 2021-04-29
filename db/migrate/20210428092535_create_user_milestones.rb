class CreateUserMilestones < ActiveRecord::Migration[6.1]
  def change
    create_table :user_milestones do |t|
      t.integer :user_id
      t.integer :milestone_id
      t.boolean :published_to_slack, default: false
      t.timestamps
    end
  end
end
