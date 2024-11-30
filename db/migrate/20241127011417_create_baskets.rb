class CreateBaskets < ActiveRecord::Migration[6.0]
  def change
    create_table :baskets do |t|
      t.references :user, null: false, foreign_key: true
      t.references :course, null: false, foreign_key: { on_delete: :cascade }

      t.timestamps
    end
  end
end
