class CreateAddresses < ActiveRecord::Migration[7.2]
  def change
    create_table :addresses do |t|
      t.references :user, null: false, foreign_key: true
      t.string :line1
      t.string :line2
      t.string :country
      t.string :city
      t.string :postcode

      t.timestamps
    end
  end
end
