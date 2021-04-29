class AddIndexToProjectsUsers < ActiveRecord::Migration[6.1]
  def change
    add_index :projects_users, [:project_id, :user_id], :unique => true
    add_index :projects_users, :user_id
  end
end
