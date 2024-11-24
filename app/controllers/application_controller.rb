class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  # 로그인 성공 후 루트 페이지로 이동
  def after_sign_in_path_for(resource)
    root_path
  end

  protected

  # Strong Parameters 설정
  def configure_permitted_parameters
    added_attrs = [:username, :email, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit(:sign_up, keys: added_attrs)
    devise_parameter_sanitizer.permit(:account_update, keys: added_attrs)
  end
end
