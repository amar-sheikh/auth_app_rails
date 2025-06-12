class CreateTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :address, null: false, foreign_key: true
      t.string :idempotency_key
      t.decimal :amount, precision: 8, scale: 2
      t.string :additional_info

      t.timestamps
    end
  end
end
