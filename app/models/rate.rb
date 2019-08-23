class Rate < ApplicationRecord
  belongs_to :user
  belongs_to :rater, :class_name => 'User'
  
  validate :age
  
  private
  
  def age
    if self.user.age < 18 && rater.age >= 18
      errors.add(:base, "You cannot rate users under 18")
    elsif rater.age < 18 && user.age >= 18
      errors.add(:base, "You cannot rate users over 18")
    end
  end
end
