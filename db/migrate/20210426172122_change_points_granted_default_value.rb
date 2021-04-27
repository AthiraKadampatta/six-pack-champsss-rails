class ChangePointsGrantedDefaultValue < ActiveRecord::Migration[6.1]
  def change
    change_column :activities, :points_requested, :integer, default: 0
    change_column :activities, :points_granted, :integer, default: 0
  end
end
