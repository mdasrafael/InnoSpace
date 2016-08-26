class User < ActiveRecord::Base
  after_initialize :set_default_role, :if => :new_record?
  mount_uploader :avatar, AvatarUploader

  def set_default_role
    self.role ||= :user
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :validatable, :confirmable, :omniauthable, :omniauth_providers => [:facebook, :google_oauth2]

  validates :firstname, :lastname, presence: true, length: {maximum: 50}

  has_many :spaces
  has_many :bookings
  has_many :reviews

  def self.from_omniauth(auth)
    user = User.where(email: auth.info.email).first

    if user
      return user
    else
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.firstname = auth.info.first_name
        user.lastname = auth.info.last_name
        user.provider = auth.provider
        user.uid = auth.uid
        user.email = auth.info.email
        user.remote_avatar_url = auth.info.image.gsub('http://','https://')
        user.password = Devise.friendly_token[0,20]
      end
    end
  end
end
