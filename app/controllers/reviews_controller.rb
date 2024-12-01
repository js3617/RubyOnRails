class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_course, only: [:index, :create]
  before_action :ensure_user_enrolled_in_course, only: [:create]
  before_action :find_review, only: [:destroy, :like, :unlike, :reply]

  def index
    @reviews = @course.reviews.where(parent_id: nil).includes(:user, :replies)
    @review = Review.new
  end

  def create
    Rails.logger.info "Received params: #{params.inspect}"

    @course = Course.find(params[:course_id])
    @review = @course.reviews.new(
      user: current_user,
      rating: params[:rating],
      review: params[:review]
    )

    if @review.save
      flash[:notice] = "수강평이 성공적으로 작성되었습니다."
    else
      flash[:alert] = @review.errors.full_messages.to_sentence
    end
    redirect_to course_path(@course)
  end

  # 리뷰 삭제
  def destroy
    if @review.user == current_user
      @review.destroy
      redirect_to course_reviews_path(@review.course), notice: "리뷰가 삭제되었습니다."
    else
      redirect_to course_reviews_path(@review.course), alert: "삭제 권한이 없습니다."
    end
  end

  # 좋아요
  def like
    if already_liked?
      render json: { error: "이미 좋아요를 눌렀습니다." }, status: :unprocessable_entity
    else
      session["liked_review_#{@review.id}"] = true
      @review.increment_likes_count!
      render json: { likes_count: @review.likes_count }
    end
  end

  # 좋아요 취소
  def unlike
    if already_liked?
      session.delete("liked_review_#{@review.id}")
      @review.decrement_likes_count!
      render json: { likes_count: @review.likes_count }
    else
      render json: { error: "좋아요를 누른 기록이 없습니다." }, status: :unprocessable_entity
    end
  end

  # 대댓글 생성
  def reply
    reply = @review.replies.new(
      user: current_user,
      review: params[:review]
    )
    if reply.save
      redirect_to course_reviews_path(@review.course), notice: "대댓글이 성공적으로 작성되었습니다."
    else
      redirect_to course_reviews_path(@review.course), alert: reply.errors.full_messages.to_sentence
    end
  end

  private

  # 수강 확인
  def ensure_user_enrolled_in_course
    unless current_user.take_courses.exists?(course_id: params[:course_id])
      flash[:alert] = "이 강의를 수강한 사용자만 리뷰를 작성할 수 있습니다."
      redirect_to course_path(params[:course_id])
    end
  end

  # 리뷰 가져오기
  def find_review
    @review = Review.find(params[:id])
  end

  # 강의 가져오기
  def find_course
    @course = Course.find(params[:course_id])
  end
	
  def already_liked?
    session["liked_review_#{@review.id}"].present?
  end
end
