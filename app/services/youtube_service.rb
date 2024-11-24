require 'google/apis/youtube_v3'

class YoutubeService
  def initialize(api_key)
    @youtube = Google::Apis::YoutubeV3::YouTubeService.new
    @youtube.key = api_key
  end

  # 재생목록 정보 가져오기
  def fetch_playlist(playlist_id)
    response = @youtube.list_playlists('snippet', id: playlist_id)

    if response.items.empty?
      raise "재생목록을 찾을 수 없습니다: #{playlist_id}"
    end

    snippet = response.items.first.snippet
	thumbnails = snippet.thumbnails
    {
      title: snippet.title,
      description: snippet.description,
      channel_title: snippet.channel_title,
      thumbnail_url: thumbnails&.high&.url || thumbnails&.default&.url
    }
  rescue Google::Apis::ClientError => e
    Rails.logger.error "YouTube API Client Error in fetch_playlist: #{e.message}"
    raise "YouTube API 호출 중 오류가 발생했습니다."
  rescue StandardError => e
    Rails.logger.error "Unexpected error in fetch_playlist: #{e.message}"
    raise "알 수 없는 오류가 발생했습니다."
  end

  # 재생목록의 모든 영상 정보 가져오기
  def fetch_videos(playlist_id)
  all_videos = []
  next_page_token = nil

  begin
    loop do
      response = @youtube.list_playlist_items(
        'snippet,contentDetails',
        playlist_id: playlist_id,
        max_results: 50,
        page_token: next_page_token
      )

      if response.items.empty?
        Rails.logger.warn "재생목록에 영상이 없습니다: #{playlist_id}"
        break
      end

      response.items.each do |item|
        snippet = item.snippet
        content_details = item.content_details

        # 영상 상세 정보 가져오기
        video_details = fetch_video_details(content_details.video_id)
		  
		thumbnail_url = snippet.thumbnails&.high&.url || snippet.thumbnails&.default&.url
		  
        if video_details[:duration].nil?
          Rails.logger.warn "영상 정보를 찾을 수 없어 제외됨: #{content_details.video_id}"
          next
        end

        all_videos << {
          lesson_name: snippet.title,
          description: snippet.description,
          youtube_video_id: content_details.video_id,
          duration: video_details[:duration],
		  thumbnail_url: thumbnail_url
        }
      end

        next_page_token = response.next_page_token
          break if next_page_token.nil?
        end
    rescue Google::Apis::ClientError => e
      Rails.logger.error "YouTube API Client Error in fetch_videos: #{e.message}"
    rescue StandardError => e
      Rails.logger.error "Unexpected error in fetch_videos: #{e.message}"
    end

    all_videos
  end


  # YouTube Videos API로 영상 세부 정보 가져오기
  def fetch_video_details(video_id)
    response = @youtube.list_videos('contentDetails', id: video_id)

    if response.items.empty?
      Rails.logger.warn "영상 정보를 찾을 수 없습니다: #{video_id}"
      return { duration: nil }
    end

    content_details = response.items.first.content_details
    {
      duration: parse_duration(content_details.duration) # ISO 8601 → "HH:MM:SS"
    }
  end

  # ISO 8601 형식의 시간을 "HH:MM:SS"로 변환
  def parse_duration(iso8601_duration)
    match = iso8601_duration.match(/PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?/)
    hours = match[1].to_i
    minutes = match[2].to_i
    seconds = match[3].to_i
    format('%02d:%02d:%02d', hours, minutes, seconds)
  end
end
