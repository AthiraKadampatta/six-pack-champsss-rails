class ChangePointsTransactionColumnName < ActiveRecord::Migration[6.1]
  def change
    rename_column :points_transactions, :type, :txn_type
  end
end
