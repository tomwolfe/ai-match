desc "This task is called by the Heroku scheduler add-on."
task :update_predictions => :environment do
  puts "Updating predictions..."
  PredictionsWorker.perform_async
  puts "done."
end