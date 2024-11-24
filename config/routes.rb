Rails.application.routes.draw do
  resources :courses do
	  collection do
		  post :import_youtube
	  end
  end
	
  resources :class_lists
  
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  # root to: 'dashboard#index' # 기본 루트 경로
  root 'courses#index'
  get 'dashboard', to: 'dashboard#index', as: :dashboard

end
