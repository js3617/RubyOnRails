class TakeCourse < ApplicationRecord
  belongs_to :user
  belongs_to :course
	
  validates :start_date, presence: true
  validates :user_id, uniqueness: { scope: :course_id, message: '이미 수강 중인 강의입니다.' }
  validates :course_id, presence: true
end
