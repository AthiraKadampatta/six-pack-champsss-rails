class CreatePointTransactionsTable < ActiveRecord::Migration[6.1]
  def change
    create_table :points_transactions do |t|
      t.integer :user_id
      t.integer :transactable_id
      t.string :transactable_type
      t.integer :points
      t.integer :type
      t.timestamps
    end
  end
end
