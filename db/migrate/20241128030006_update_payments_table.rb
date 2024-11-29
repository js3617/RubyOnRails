class UpdatePaymentsTable < ActiveRecord::Migration[6.0]
  def change
    change_column :payments, :status, :string, default: "pending", null: false
    add_column :payments, :payment_method, :string, null: true # 카드, 계좌이체 등
    add_column :payments, :pg_provider, :string, null: true # PG사 정보 (e.g., html5_inicis)
  end
end
