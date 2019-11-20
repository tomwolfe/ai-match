class PredictionsWorker
  include Sidekiq::Worker
  sidekiq_options retry: false
  
  def perform
    #generate table of size User_countxUser_count
    #User.count
    #snippet = Snippet.find(snippet_id)
    #uri = URI.parse("http://pygments.appspot.com/")
    #request = Net::HTTP.post_form(uri, lang: snippet.language, code: snippet.plain_code)
    #snippet.update_attribute(:highlighted_code, request.body)
  end
end