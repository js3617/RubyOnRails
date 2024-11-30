class CreateTakeCourses < ActiveRecord::Migration[6.0]
  def change
    create_table :take_courses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :course, null: false, foreign_key: true
      t.datetime :start_date, null: false, default: -> { 'CURRENT_TIMESTAMP' }

      t.timestamps
    end
	
	add_index :take_courses, [:user_id, :course_id], unique: true
	  
  end
end
