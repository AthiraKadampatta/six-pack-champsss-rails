class AddPointsPerHourColumnToProjects < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :points_per_hour, :integer
  end
end
