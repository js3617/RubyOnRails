class CreateCourses < ActiveRecord::Migration[6.0]
  def change
    create_table :courses do |t|
      t.string :class_name, null: false
      t.text :description
      t.string :youtube_playlist_id, null: false, unique: true
      t.integer :price, default: 0
      t.integer :rating, default: 0
      t.integer :like, default: 0
      t.string :level, default: '초급'
      t.boolean :certificate, default: false
      t.integer :sessions_count, default: 0
      t.string :provider

      t.timestamps
    end
  end
end
