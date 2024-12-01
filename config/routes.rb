Rails.application.routes.draw do
  get 'review/create'
  	resources :courses do
	  	collection do
		  	post :import_youtube
	  	end
  	end
	
	# 강의 상세 라우팅
  	resources :courses, only: [:show]
  	resources :class_lists
	
	# 수강바구니 라우팅
  	resources :baskets, only: [:index, :create, :destroy]

	# 결제 라우팅
	resources :payments, only: [:index, :show, :create]
	
	# 수강목록 라우팅
  	resources :take_courses, only: [:index]
 	
	# 리뷰 작성
	resources :courses do
	  resources :reviews, only: [:create, :destroy] do
		member do
		  post :like
		  delete :unlike
		  post :reply
		end
	  end
	end
	
	resources :courses do
	  resources :class_lists, only: [:show]
	end
	
	# 로그인/회원가입 라우팅
  	devise_for :users, controllers: {
    	omniauth_callbacks: 'users/omniauth_callbacks'
  	}
  	# root to: 'dashboard#index' # 기본 루트 경로
  	root 'courses#index'
  	get 'dashboard', to: 'dashboard#index', as: :dashboard
  	get "mypage" => "home#mypage"
end
