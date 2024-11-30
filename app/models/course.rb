class Course < ApplicationRecord
	has_many :class_lists, dependent: :destroy
	has_many :baskets, dependent: :destroy
  	has_many :users, through: :baskets
	has_many :users, through: :take_courses
    has_many :payment_items, through: :baskets
	has_many :take_courses, dependent: :destroy
	
    validates :class_name, :youtube_playlist_id, presence: true
    validates :thumbnail_url, presence: true

  	def refresh_sessions_count!
    	update(sessions_count: class_lists.size)
  	end
end
