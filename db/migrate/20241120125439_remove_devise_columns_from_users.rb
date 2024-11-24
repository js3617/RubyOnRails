class RemoveDeviseColumnsFromUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :username, :string
    remove_column :users, :uid, :string
    remove_column :users, :provider, :string
  end
end
