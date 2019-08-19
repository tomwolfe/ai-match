class Rate < ApplicationRecord
  belongs_to :user, dependent: :destroy
  belongs_to :rater, :class_name => 'User', dependent: :destroy
  
  validate :age
  
  def age
    if user.age < 18 && rater.age >= 18
      errors.add(:base, "You cannot rate users under 18")
    elsif rater.age < 18 && user.age >= 18
      errors.add(:base, "You cannot rate users over 18")
    end
  end
end
