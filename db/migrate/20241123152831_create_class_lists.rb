class CreateClassLists < ActiveRecord::Migration[6.0]
  def change
    create_table :class_lists do |t|
      t.references :course, null: false, foreign_key: true
      t.string :lesson_name, null: false
      t.text :description
      t.string :youtube_video_id, null: false, unique: true
      t.string :duration

      t.timestamps
    end
  end
end
