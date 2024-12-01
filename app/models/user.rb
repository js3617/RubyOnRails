class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
		 :omniauthable, omniauth_providers: [:google_oauth2, :kakao]
	
  has_many :baskets, dependent: :destroy
  has_many :courses, through: :baskets
  
  has_many :payments, dependent: :destroy
  has_many :payment_items, through: :payments
	
  has_many :take_courses, dependent: :destroy
  has_many :courses, through: :take_courses	
	
  has_many :reviews, dependent: :destroy
  # username은 반드시 입력되어야 함
  validates :username, presence: true	
	
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.uid = auth.uid
	  user.email = auth.info.email || "#{auth.uid}@kakao.com"
      user.password = Devise.friendly_token[0, 20]
      user.username = auth.info.name
	Rails.logger.info "Provider: #{auth.provider}, UID: #{auth.uid}, Email: #{auth.info.email}"
    end
  end
end
