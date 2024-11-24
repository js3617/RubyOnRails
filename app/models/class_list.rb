class ClassList < ApplicationRecord
  belongs_to :course

  validates :lesson_name, :thumbnail_url, presence: true
  validates :youtube_video_id, uniqueness: true
end
