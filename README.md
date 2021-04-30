# KLAP APIs

Kiprosh Laureate Awards Portal (KLAP) is a portal which we have created for the Kiprosh associates. Associates can login to this portal and claim for points if they have contributed to other departments like Hiring, KFC, & COE of the Organization.

### Technology Stack

- [rails-api](https://github.com/rails-api/rails-api)
- [jbuilder](https://github.com/rails/jbuilder)
- [rspec](https://github.com/rspec/rspec-rails)
- [apipie-rails](https://github.com/Apipie/apipie-rails)
- [travis](https://github.com/travis-ci/travis.rb)
- [jwt](https://github.com/jwt/ruby-jwt)
- [faraday](https://github.com/lostisland/faraday)
- [google-id-token](https://github.com/google/google-id-token)
- [sidekiq](https://github.com/mperham/sidekiq)
- [whenever](https://github.com/javan/whenever)

### Documentation Link

The APIs have been documented - [here](https://six-pack-champsss-rails.herokuapp.com/apipie)

* Ruby version - ruby-3.0.1

* System dependencies - Whenever gem runs cron job for Slack notification

* Configuration - export CORS_ORIGINS = "https://kipklaps.vercel.app,http://localhost:4000"

* Database creation - bundle exec rails db:create

* Database initialization - bundle exec rake db:seed

* How to run the test suite -  bundle exec rspec filename

* Services - CRON Job for Slack notification using Whenever gem

* Deployment instructions - Auto deployed once Travis build passes. Need to run `bundle exec rails db:migrate` manually
