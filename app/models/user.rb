class User < ApplicationRecord
  has_many :raters, :class_name => 'Rate', :foreign_key => 'user_id'
  has_many :ratings, :class_name => 'Rate', :foreign_key => 'rater_id'
  
  scope :minor, -> { where("age < ?", 18) }
  scope :adult, -> { where("age >= ?", 18) }
  
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  geocoded_by :location
  after_validation :geocode, if: ->(obj){ obj.location.present? and obj.location_changed? }
  
  def self.build_with_omniauth(auth)
    build do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
      user.picture = auth["info"]["image"]
      user.location = auth["info"]["location"]
      user.twitter = auth["info"]["urls"]["Twitter"]
    end
  end
end
