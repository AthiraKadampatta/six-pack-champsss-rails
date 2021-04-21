class AddAdditionalColumnsToActivities < ActiveRecord::Migration[6.1]
  def change
    add_column :activities, :status, :integer
    add_column :activities, :points_granted, :integer
    add_column :activities, :reviewed_by, :integer
    add_column :activities, :reviewed_at, :datetime
  end
end
