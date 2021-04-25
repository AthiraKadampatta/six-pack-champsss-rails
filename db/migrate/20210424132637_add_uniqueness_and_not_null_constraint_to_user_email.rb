class AddUniquenessAndNotNullConstraintToUserEmail < ActiveRecord::Migration[6.1]
  def change
    remove_index :users, :email
    add_index :users, :email, unique: true

    change_column_null :users, :email, false
  end
end
