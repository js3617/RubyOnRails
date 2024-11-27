class Course < ApplicationRecord
	has_many :class_lists, dependent: :destroy
	has_many :baskets, dependent: :destroy
  	has_many :users, through: :baskets
	
    validates :class_name, :youtube_playlist_id, presence: true
    validates :thumbnail_url, presence: true

  	def refresh_sessions_count!
    	update(sessions_count: class_lists.size)
  	end
end
