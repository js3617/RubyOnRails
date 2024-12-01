class Review < ApplicationRecord
  	belongs_to :user
  	belongs_to :course
  	has_many :replies, class_name: "Review", foreign_key: :parent_id, dependent: :destroy
  	belongs_to :parent, class_name: "Review", optional: true

  	validates :review, presence: true
  	validates :rating, inclusion: { in: 1..5 }, allow_nil: true

  	# 좋아요 수 증가
	def increment_likes_count!
		self.likes_count ||= 0
		self.likes_count += 1
		save!
	end

	# 좋아요 수 감소
	def decrement_likes_count!
		self.likes_count ||= 0
		self.likes_count -= 1 if likes_count > 0
		save!
	end
end
