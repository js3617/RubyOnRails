class ClassListsController < ApplicationController
  before_action :set_class_list, only: [:show, :edit, :update, :destroy]
  before_action :find_course
  before_action :find_class_list
  before_action :ensure_user_enrolled_in_course

  # GET /class_lists
  # GET /class_lists.json
  def index
    @class_lists = ClassList.all
  end

  # GET /class_lists/1
  # GET /class_lists/1.json
  def show
  end

  # GET /class_lists/new
  def new
    @class_list = ClassList.new
  end

  # GET /class_lists/1/edit
  def edit
  end

  # POST /class_lists
  # POST /class_lists.json
  def create
    @class_list = ClassList.new(class_list_params)

    respond_to do |format|
      if @class_list.save
        format.html { redirect_to @class_list, notice: 'Class list was successfully created.' }
        format.json { render :show, status: :created, location: @class_list }
      else
        format.html { render :new }
        format.json { render json: @class_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /class_lists/1
  # PATCH/PUT /class_lists/1.json
  def update
    respond_to do |format|
      if @class_list.update(class_list_params)
        format.html { redirect_to @class_list, notice: 'Class list was successfully updated.' }
        format.json { render :show, status: :ok, location: @class_list }
      else
        format.html { render :edit }
        format.json { render json: @class_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /class_lists/1
  # DELETE /class_lists/1.json
  def destroy
    @class_list.destroy
    respond_to do |format|
      format.html { redirect_to class_lists_url, notice: 'Class list was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_class_list
      	@class_list = ClassList.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def class_list_params
      	params.require(:class_list).permit(:course_id, :lesson_name, :description, :youtube_video_id, :duration)
    end
	
	private

  	def find_course
    	@course = Course.find(params[:course_id])
  	end

  	def find_class_list
    	@class_list = @course.class_lists.find(params[:id])
  	end
	
	def ensure_user_enrolled_in_course
      unless current_user.take_courses.exists?(course_id: @course.id)
      	flash[:alert] = "강의를 수강 중인 사용자만 강의 영상을 볼 수 있습니다."
      	redirect_to course_path(@course)
    end
  end
end
