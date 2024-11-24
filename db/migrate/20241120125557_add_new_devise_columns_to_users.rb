class AddNewDeviseColumnsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :username, :string, null: false
    add_column :users, :provider, :string
    add_column :users, :uid, :string
  end
end
