class AddCurrentAddressToUsers < ActiveRecord::Migration[7.2]
  def change
    add_reference :users, :current_address, foreign_key: { to_table: :addresses }, null: true
  end
end
