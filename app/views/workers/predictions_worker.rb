class PredictionsWorker
  include Sidekiq::Worker
  sidekiq_options retry: false
  
  def perform
    Prediction.generate_predictions
  end
end