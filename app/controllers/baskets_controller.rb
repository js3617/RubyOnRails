class BasketsController < ApplicationController
	before_action :authenticate_user!

  	def index
    	@baskets = current_user.baskets.includes(:course)
    	render json: @baskets.as_json(include: :course)
  	end

  	def create
    	basket = current_user.baskets.new(course_id: params[:course_id])

    	if basket.save
      		flash[:notice] = "강의가 수강바구니에 추가되었습니다."
    	else
      		flash[:alert] = "강의를 수강바구니에 추가할 수 없습니다: #{basket.errors.full_messages.to_sentence}"
    	end	
    	redirect_to course_path(params[:course_id]) # 해당 강의 페이지로 리다이렉트
  	end

  	def destroy
    	basket = current_user.baskets.find_by(course_id: params[:course_id])
    	if basket&.destroy
      		render json: { success: true }
    	else
      	render json: { success: false, message: "Failed to remove course from cart" }, status: :unprocessable_entity
    	end
  	end
end
