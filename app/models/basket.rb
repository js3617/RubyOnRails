class Basket < ApplicationRecord
  belongs_to :user
  belongs_to :course
  
  validates :user_id, presence: true
  validates :course_id, presence: true
  validate :valid_course_and_user

  private

  def valid_course_and_user
    errors.add(:course, "존재하지 않는 강의입니다.") unless Course.exists?(id: course_id)
    errors.add(:user, "존재하지 않는 사용자입니다.") unless User.exists?(id: user_id)
  end
end
