class Prediction < ApplicationRecord
  belongs_to :user
  belongs_to :predictor, :class_name => 'User'
  
  def self.generate_predictions(iterations = 10, num_features = 10, regularization = 1)
    mutual_likes=Rate.where(value: true).joins("INNER JOIN Rates r2 ON Rates.user_id=r2.rater_id AND Rates.rater_id=r2.user_id")
    dislikes=Rate.where(value: false)
    
    # tradeoff between performance/space/complexity. for now User/Track cannot be destroyed w/o breaking predictions
    #		alternate solution https://github.com/tomwolfe/musicrecommendation/commit/ebd68d29f34d6da2c7b1ca6dc4b201399aa87423#app/models/rating.rb
    #		hashes id => index
    rating_table = self.build_rating_table(mutual_likes, dislikes)
    calc = CofiCost.new(rating_table, num_features, regularization, iterations, 2, 1, nil, nil)
    calc.min_cost
    @predictions = calc.predictions
    self.add_predictions
  end
  
  def self.build_rating_table(mutual_likes, dislikes)
    self.index_users
    user_count = User.count
    rating_table = NArray.float(user_count,user_count).fill(0.0)
    mutual_likes.each do |rating|
      rating_table[@user_index[rating.user_id], @user_index[rating.rater_id]] = 2
    end
    dislikes.each do |rating|
      rating_table[@user_index[rating.user_id], @user_index[rating.rater_id]] = 1
      rating_table[@user_index[rating.rater_id], @user_index[rating.user_id]] = 1
    end
    rating_table
  end
  
  def self.index_users
    users=User.all
    @user_index = {}
    users.each_with_index do |user, index|
      @user_index[user.id]=index
    end
  end
  
  def self.add_predictions
    old_predictions = Prediction.all
    @predictions.shape[0].times do |i|
      @predictions.shape[1].times do |j|
        user_deindexed = @user_index.key(i)
        predictor_deindexed = @user_index.key(j)
        old = old_predictions.where(user_id: user_deindexed, predictor_id: predictor_deindexed).first
        value=@predictions[j,i]-1
        unless old.nil?
          unless (old.value - value).abs.between?(0,0.1)
            old.update(value: value)
          end
        else
          Prediction.create(user_id: user_deindexed, predictor_id: predictor_deindexed, value: value)
        end
      end
    end
  end
end
