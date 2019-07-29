class User < ApplicationRecord
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_nil: true
  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
      user.picture = auth["info"]["image"]
      user.location = auth["info"]["location"]
      user.twitter = auth["info"]["urls"]["Twitter"]
    end
  end
end
