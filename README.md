# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration
OmniAuth login for development can be achieved by creating a file /config/app_environment_variables.rb with keys/tokens as such:
ENV['TWITTER_KEY']='key'
ENV['TWITTER_SECRET']='secret'
for production you can just set the ENV variables on Heroku or whatever.
heroku buildpacks:add https://github.com/nolman/heroku-gsl-buildpack.git --index=1
https://github.com/mperham/sidekiq/wiki/Deployment#heroku:
heroku config:set MALLOC_ARENA_MAX=2
heroku addons:create redistogo
heroku config:set REDIS_PROVIDER=REDISTOGO_URL
heroku addons:create heroku-redis:hobby-dev
heroku addons:create scheduler:standard
Open dashboard and create a new job: (https://devcenter.heroku.com/articles/scheduler)
rake update_predictions

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
