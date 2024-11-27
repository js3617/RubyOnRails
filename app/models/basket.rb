class Basket < ApplicationRecord
  belongs_to :user
  belongs_to :course
  
  # 중복검사 본인이 이미 추가한 강의를 추가할 수 없음
  validates :course_id, uniqueness: { scope: :user_id, message: "이미 수강바구니에 존재합니다." }
end
