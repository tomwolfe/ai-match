class User < ApplicationRecord
  has_many :raters, :class_name => 'Rate', :foreign_key => 'user_id', dependent: :destroy
  has_many :ratings, :class_name => 'Rate', :foreign_key => 'rater_id', dependent: :destroy
  
  scope :minor, -> { where("age < ?", 18) }
  scope :adult, -> { where("age >= ?", 18) }
  
  validates :age, numericality: { greater_than_or_equal_to: 13 }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  geocoded_by :location
  after_validation :geocode, if: ->(obj){ obj.location.present? and obj.location_changed? }
  
  def self.create_with_omniauth(auth)
    User.create!(:provider => auth["provider"], :uid => auth["uid"], :name => auth["info"]["name"], :picture => auth["info"]["image"], :location => auth["info"]["location"], :twitter => auth["info"]["urls"]["Twitter"])
  end
  
  def self.handle_minors(users, current_user, associated_user=false)
    #users=users.minor if current_user.age < 18
    #users=users.adult if current_user.age >= 18
    if associated_user
      if current_user.age >= 18
        users=users.where(users: { age: 18..99})
      else
        users=users.where(users: { age: 13..17})
      end
    else
      if current_user.age >= 18
        users=users.where(age: 18..99)
      else
        users=users.where(age: 13..17)
      end
    end
  end
end
