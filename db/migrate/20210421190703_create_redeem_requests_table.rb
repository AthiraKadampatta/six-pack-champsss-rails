class CreateRedeemRequestsTable < ActiveRecord::Migration[6.1]
  def change
    create_table :redeem_requests do |t|
      t.integer :user_id
      t.integer :points
      t.integer :status
      t.integer :reward_id
      t.timestamps
    end
  end
end
