class User < ApplicationRecord
  has_many :ratings
  has_many :rated_users, through: :rating, class_name: "User", foreign_key: :rated_user_id # The users this user has rated
  has_many :rated_by_users, through: :rating, class_name: "User", foreign_key: :rating_user_id # The users that have rated this user
  has_many :matches
  has_many :matched_users, through: :match, class_name: "User", foreign_key: :matched_user_id # The users this user has matched
  has_many :matched_by_users, through: :match, class_name: "User", foreign_key: :matching_user_id # The users that have matched this user
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  geocoded_by :location
  after_validation :geocode, if: ->(obj){ obj.location.present? and obj.location_changed? }
  
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
