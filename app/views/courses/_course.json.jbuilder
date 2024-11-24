json.extract! course, :id, :class_name, :description, :youtube_playlist_id, :price, :rating, :like, :level, :certificate, :sessions_count, :provider, :created_at, :updated_at
json.url course_url(course, format: :json)
