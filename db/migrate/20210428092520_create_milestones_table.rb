class CreateMilestonesTable < ActiveRecord::Migration[6.1]
  def change
    create_table :milestones do |t|
      t.integer :value

      t.timestamps
    end
  end
end
