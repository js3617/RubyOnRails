Rails.application.routes.draw do
  	resources :courses do
	  	collection do
		  	post :import_youtube
	  	end
  	end
	
  	resources :courses, only: [:show] # 강의 상세 페이지
  	resources :class_lists
	
  	resources :baskets, only: [:index, :create, :destroy]

	resources :payments, only: [:index, :show, :create]
  	resources :take_courses, only: [:index]
 
  	devise_for :users, controllers: {
    	omniauth_callbacks: 'users/omniauth_callbacks'
  	}
  	# root to: 'dashboard#index' # 기본 루트 경로
  	root 'courses#index'
  	get 'dashboard', to: 'dashboard#index', as: :dashboard
  	get "mypage" => "home#mypage"
end
