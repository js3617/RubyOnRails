class CreatePaymentItems < ActiveRecord::Migration[6.0]
  def change
    create_table :payment_items do |t|
      t.references :payment, null: false, foreign_key: true
      t.references :basket, null: false, foreign_key: true

      t.timestamps
    end
  end
end
