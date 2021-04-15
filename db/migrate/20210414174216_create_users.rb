class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :token
      t.string :email
      t.integer :role_id

      t.timestamps
    end
  end
end
