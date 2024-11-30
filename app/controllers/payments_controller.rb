class PaymentsController < ApplicationController
	require 'rest-client'
	before_action :authenticate_user!

  	# 결제 내역 리스트
    def index
      	@payments = current_user.payments.order(created_at: :desc) # 최신 결제 내역부터 표시
    end

    # 결제 세부 정보
    def show
       	@payment = Payment.find(params[:id])
    end
	
	def new
		@amount = params[:amount] || 1000 # 결제 금액
    	@order_id = "order_#{SecureRandom.uuid}" # 고유 주문 번호
  	end
	
    def create
    	# 파라미터 추출
		imp_uid = params[:imp_uid]
		paid_amount = params[:paid_amount].to_f
		pay_method = params[:pay_method]
		pg_provider = params[:pg_provider]
		selected_basket_ids = params[:selected_basket_ids]

		# 선택된 바구니 가져오기
		baskets = current_user.baskets.where(id: selected_basket_ids)

		if baskets.empty?
		  render json: { status: 'failed', message: '선택된 바구니 항목이 없습니다.' }, status: :unprocessable_entity
		  return
		end

		# 총 결제 금액 계산
		total_amount = baskets.joins(:course).sum('courses.price')

		# 금액 검증
		if total_amount != paid_amount
		  render json: { status: 'failed', message: '결제 금액 불일치' }, status: :unprocessable_entity
		  return
		end
		
		# 무료 강의 처리
	    if total_amount.zero?
		  handle_free_payment(baskets)
		  return
	    end

		# Payment 생성
		payment = current_user.payments.new(
		  amount: total_amount,
		  status: "completed",
		  transaction_id: imp_uid,
		  payment_method: pay_method,
		  pg_provider: pg_provider
		)

		if payment.save
		  	baskets.each do |basket|
				payment.payment_items.create(course_id: basket.course_id)
			
				Rails.logger.info "TakeCourse 생성 시도: User=#{current_user.id}, Course=#{basket.course_id}"
    
				TakeCourse.create!(
				  user_id: current_user.id,
				  course_id: basket.course_id,
				  start_date: Time.current
				)

				Rails.logger.info "TakeCourse 생성 완료"
			end

		  	baskets.destroy_all
		  	render json: { status: 'completed', payment_id: payment.id }
		else
		  	render json: { status: 'failed', message: payment.errors.full_messages.join(', ') }, status: :unprocessable_entity
		end
	end

	
	def complete
	  Rails.logger.info "결제 완료 요청: #{params.inspect}"

	  # Portone에서 결제 검증
	  payment = current_user.payments.create(
		amount: params[:paid_amount],
		status: params[:status],
		transaction_id: params[:imp_uid],
		pg_provider: params[:pg_provider],
		payment_method: params[:pay_method]
	  )

	  if payment.persisted?
		# 결제된 강의를 수강바구니에서 제거
		selected_courses = params[:selected_course_ids] # 선택된 강의 ID
		if selected_courses.present?
		  current_user.baskets.where(course_id: selected_courses).destroy_all
		end

		flash[:notice] = "결제가 성공적으로 완료되었습니다."
		redirect_to payment_path(payment)
	  else
		flash[:alert] = "결제 정보를 저장하는 중 문제가 발생했습니다."
		redirect_to baskets_path
	  end
    end

	
  	def verify
    	payment = current_user.payments.find(params[:id])
    	iamport = Iamport.client

    	response = iamport.find(params[:imp_uid])
    	if response['code'] != 0 || response['response']['amount'] != payment.amount.to_f
      		payment.update(status: "failed")
      		flash[:alert] = "결제 검증 실패: #{response['message']}"
    	else
      		payment.update(status: "completed", transaction_id: params[:imp_uid])
      		payment.baskets.destroy_all
      		flash[:notice] = "결제가 완료되었습니다."
    	end

		redirect_to payments_path
	 end
	
	def destroy
		payment = current_user.payments.find_by(id: params[:id])

		if payment
		  payment.destroy
		  flash[:notice] = "결제가 삭제되었습니다."
		else
		  flash[:alert] = "삭제할 결제를 찾을 수 없습니다."
		end

		redirect_to payments_path
	end
	
	private
	
	# 무료 결제 처리
	def handle_free_payment(baskets)
		payment = Payment.create!(
		  user: current_user,
		  amount: 0,
		  status: "completed", # 무료 강의는 결제 완료 상태로 저장
		  payment_method: "free", # 결제 방법은 free로 저장
		  pg_provider: "none" # PG사 없음
		)

		create_payment_items(payment, baskets)
		baskets.destroy_all

		render json: { status: "completed", payment_id: payment.id }
	end
	
	# PaymentItem 생성
	def create_payment_items(payment, baskets)
		baskets.each do |basket|
			payment.payment_items.create!(course_id: basket.course_id)
			
			Rails.logger.info "TakeCourse 생성 시도: User=#{current_user.id}, Course=#{basket.course_id}"
    
			TakeCourse.create!(
				user_id: current_user.id,
				course_id: basket.course_id,
				start_date: Time.current
			)

			Rails.logger.info "TakeCourse 생성 완료"
		end
	end
end
