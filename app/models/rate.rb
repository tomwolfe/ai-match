class Rate < ApplicationRecord
  belongs_to :user, dependent: :destroy
  belongs_to :rater, :class_name => 'User', dependent: :destroy
end
