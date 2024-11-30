class BasketsController < ApplicationController
  before_action :authenticate_user!

  # 수강바구니 리스트 페이지
  def index
    @basket_courses = current_user.baskets.includes(:course)
  end

  def create
    basket = Basket.create(
		course_id: params[:course_id], 
		user_id: current_user.id
	)
	
	if basket.save
		flash[:notice] = "장바구니에 상품이 담겼습니다."
	else
		flash[:notice] = "문제가 생겼습니다. 개발자에게 문의해주세요."
	end
	  
    redirect_back(fallback_location: root_path)
  end

  # Checkout 액션
  def checkout
    selected_baskets = current_user.baskets.where(id: params[:selected_basket_ids])

    if selected_baskets.empty?
      flash[:alert] = "결제할 강의를 선택해주세요."
      redirect_to baskets_path
      return
    end

    total_amount = selected_baskets.joins(:course).sum('courses.price')

    payment = Payment.new(
      user: current_user,
      amount: total_amount,
      status: "pending"
    )

    if payment.save
      selected_baskets.each do |basket|
        payment.payment_items.create(course_id: basket.course_id)
      end

      selected_baskets.destroy_all
      flash[:notice] = "결제가 성공적으로 완료되었습니다."
      redirect_to payment_path(payment)
    else
      flash[:alert] = "결제를 처리하는 중 문제가 발생했습니다."
      redirect_to baskets_path
    end
  end

  # 수강바구니 항목 삭제
  def destroy
	  basket = Basket.find(params[:id])

	  basket.destroy
	  redirect_back(fallback_location: root_path)
  end

  private

  # Portone 결제 준비
  def prepare_payment_with_portone(payment)
    # 1. 토큰 발급
    begin
      response = RestClient.post(
        "https://api.iamport.kr/users/getToken",
        {
          imp_key: ENV['PORTONE_API_KEY'], # API 키
          imp_secret: ENV['PORTONE_API_SECRET'] # API 시크릿
        }
      )
    rescue RestClient::ExceptionWithResponse => e
      Rails.logger.error "토큰 발급 실패: #{e.response}"
      raise "Portone 토큰 발급 중 오류 발생: #{e.response}"
    end

    token_data = JSON.parse(response.body)
    if token_data['code'] != 0
      Rails.logger.error "토큰 발급 실패: #{token_data['message']}"
      raise "Portone 토큰 발급 실패: #{token_data['message']}"
    end

    token = token_data['response']['access_token']
    Rails.logger.info "Portone 토큰 발급 성공: #{token}"

    # 2. 결제 준비
    begin
      prepare_response = RestClient.post(
        "https://api.iamport.kr/payments/prepare",
        {
          merchant_uid: payment.id.to_s, # 결제 고유 ID
          amount: payment.amount         # 결제 금액
        },
        Authorization: "Bearer #{token}" # 발급받은 인증 토큰
      )
    rescue RestClient::ExceptionWithResponse => e
      Rails.logger.error "결제 준비 실패: #{e.response}"
      raise "Portone 결제 준비 중 오류 발생: #{e.response}"
    end

    prepare_result = JSON.parse(prepare_response.body)
    if prepare_result['code'] != 0
      Rails.logger.error "결제 준비 실패: #{prepare_result['message']}"
      raise "Portone 결제 준비 실패: #{prepare_result['message']}"
    end

    Rails.logger.info "결제 준비 성공: #{prepare_result.inspect}"
  end

end
