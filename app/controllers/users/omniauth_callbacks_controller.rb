class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  #구글 소셜 로그인
  def google_oauth2
    @user = User.from_omniauth(request.env['omniauth.auth'])
    if @user.persisted?
      flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
      sign_in_and_redirect @user, event: :authentication
    else
      session['devise.google_data'] = {
        provider: request.env['omniauth.auth'].provider,
        uid: request.env['omniauth.auth'].uid,
        email: request.env['omniauth.auth'].info.email,
		username: request.env['omniauth.auth'].info.name
      }
      redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
    end
  end
	
  #카카오 소셜 로그인
  def kakao
	puts "Callback URL: #{request.original_url}"
 	puts "Kakao callback phase initiated"
  	auth_data = request.env['omniauth.auth']
  	puts "Auth data: #{auth_data.inspect}"
	  
    @user = User.from_omniauth(request.env['omniauth.auth'])
    if @user.persisted?
      flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Kakao'
      sign_in_and_redirect @user, event: :authentication
    else
      session['devise.kakao_data'] = {
        provider: request.env['omniauth.auth'].provider,
        uid: request.env['omniauth.auth'].uid,
        email: request.env['omniauth.auth'].info.email,
        username: request.env['omniauth.auth'].info.name
      }
      redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
    end
  end

  def failure
    redirect_to root_path, alert: "소셜로그인에 실패했습니다. 다시 시도해주세요."
  end
end
