class CreatePayments < ActiveRecord::Migration[6.0]
  def change
    create_table :payments do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.string :status, default: "pending"
      t.string :transaction_id

      t.timestamps
    end
  end
end
