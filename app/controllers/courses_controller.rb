class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :edit, :update, :destroy]

  # GET /courses
  # GET /courses.json
  def index
    @courses = Course.all
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
  end

  def import_youtube
    playlist_url = params[:playlist_url]
    youtube_data = parse_youtube_url(playlist_url)

    playlist_id = youtube_data[:playlist_id]
    if playlist_id.nil?
      redirect_to courses_path, alert: '유효한 YouTube 재생목록 URL을 입력하세요.'
      return
    end

    youtube_service = YoutubeService.new(ENV['YOUTUBE_API_KEY'])

    # 재생목록 정보 가져오기
    playlist_info = youtube_service.fetch_playlist(playlist_id)

    # `courses` 테이블에 저장
    course = Course.find_or_create_by!(youtube_playlist_id: playlist_id) do |c|
      c.class_name = playlist_info[:title]
      c.description = playlist_info[:description]
      c.provider = playlist_info[:channel_title]
	  c.thumbnail_url = playlist_info[:thumbnail_url]
    end

    # 재생목록의 모든 영상 정보 가져오기
    video_data = youtube_service.fetch_videos(playlist_id)

    # 비어 있는 데이터 처리
    if video_data.nil? || video_data.empty?
      redirect_to courses_path, alert: '재생목록에서 영상을 가져올 수 없습니다.'
      return
    end

    # `class_lists` 테이블에 저장
    video_data.each do |video|
      unless video.is_a?(Hash) && video[:youtube_video_id].present?
        Rails.logger.error "Invalid video data format: #{video.inspect}"
        next
      end

      course.class_lists.find_or_create_by!(youtube_video_id: video[:youtube_video_id]) do |lesson|
        lesson.lesson_name = video[:lesson_name]
        lesson.description = video[:description]
        lesson.duration = video[:duration]
		lesson.thumbnail_url = video[:thumbnail_url]
      end
    end

	course.refresh_sessions_count!
	  
    redirect_to course_path(course), notice: 'YouTube 데이터를 성공적으로 가져왔습니다.'
  end
	
  # GET /courses/new
  def new
    @course = Course.new
  end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses
  # POST /courses.json
  def create
    @course = Course.new(course_params)

    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: 'Course was successfully created.' }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1
  # PATCH/PUT /courses/1.json
  def update
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to @course, notice: 'Course was successfully updated.' }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    @course.destroy
    respond_to do |format|
      format.html { redirect_to courses_url, notice: 'Course was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def course_params
      params.require(:course).permit(:class_name, :description, :youtube_playlist_id, :price, :rating, :like, :level, :certificate, :sessions_count, :provider)
    end
  
    # URL에서 playlist_id 추출
    def parse_youtube_url(url)
      uri = URI.parse(url)
      query_params = URI.decode_www_form(uri.query || '').to_h
      playlist_id = query_params['list']
      { playlist_id: playlist_id }
    rescue URI::InvalidURIError
      { playlist_id: nil }
    end

end
