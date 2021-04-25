class RenameRoleIdToRoleUsers < ActiveRecord::Migration[6.1]
  def change
    rename_column :users, :role_id, :role
  end
end
