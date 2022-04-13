# frozen_string_literal: true

source "https://rubygems.org"

gem "active_model_serializers", "~> 0.10.0"
gem "active_record-postgres-constraints", "~> 0.1" # This can/should go away when we go to Rails 6.1
gem "acts_as_list", "~> 0.9"
gem "acts_as_tenant", "~> 0.4"
gem "attribute_normalizer", "~> 1.2"
gem "aws-sdk-s3", "~> 1.97", require: false
gem "babosa", "~> 1.0"
gem "bootsnap", "~> 1.4"
gem "bootstrap-kaminari-views", "~> 0.0"
gem "bootstrap-sass", "~> 3.4"
gem "browser", "~> 2.5"
gem "chroma", "~> 0.2"
gem "cocoon", "~> 1.2"
gem "coffee-rails", "~> 5.0"
gem "config", "~> 1.4"
gem "country_select", "~> 4.0",
    require: "country_select_without_sort_alphabetical" # Alpha sort is memory intensive?
gem "daemons", "~> 1.2"
gem "datetimepicker-rails", git: "https://github.com/zpaulovics/datetimepicker-rails",
                            branch: "master", submodules: true
gem "delayed_job_active_record", "~> 4.1"
gem "devise", "~> 4.7"
gem "diffy", "~> 3.2"
gem "draper", "~> 3.0"
gem "dropzonejs-rails", "~> 0.7"
gem "elasticsearch-model", "~> 7.0"
gem "elasticsearch-rails", "~> 7.0"
gem "exception_notification", "~> 4.1"
gem "factory_bot_rails", "~> 4.0"
gem "faker", "~> 2.0"
gem "font-awesome-sass", "~> 4.7"
gem "hirb", "~> 0.7"
gem "i18n-js", "~> 3.0"
gem "icalendar", "~> 2.0"
gem "image_processing", "~> 1.12"
gem "inline_svg", "~> 0.6"
gem "jquery-rails", "~> 4.3"
gem "kaminari", "~> 1.0"
gem "momentjs-rails", "~> 2.9", git: "https://github.com/derekprior/momentjs-rails"
gem "mustache", "~> 1.0"
gem "omniauth-google-oauth2", "~> 0.6"
gem "omniauth-rails_csrf_protection", "~> 0.1" # Related to CVE 2015 9284
gem "pg", "~> 1.1"
gem "phony_rails", "~> 0.12"
gem "puma", "~> 5.6"
gem "pundit", "~> 2.0"
gem "rails", "~> 6.0.0"
gem "rails-backbone", "~> 1.2"
gem "redcarpet", "~> 3.5"
gem "redis", "~> 4.1"
gem "rein", "~> 5.0" # This can be removed when we go to Rails 6.1.
gem "rolify", "~> 4.1"
gem "sass-rails", "~> 5.0"
gem "serviceworker-rails", "~> 0.5"
gem "simple_form", "~> 5.0"
gem "strong_password", "~> 0.0.6"
gem "timecop", "~> 0.8"
gem "uglifier", ">= 1.3.0"
gem "whenever", "~> 0.9"
gem "wisper", "~> 2.0"
gem "wisper-activerecord", "~> 1.0"
gem 'ed25519', '>= 1.2', '< 2.0'
gem 'bcrypt_pbkdf', '>= 1.0', '< 2.0'

group :development, :test do
  gem "awesome_print", "~> 1.6"
  gem "byebug", "~> 5.0"
  gem "capistrano-bundler", "~> 1.0"
  gem "capistrano-passenger", "~> 0.2"
  gem "capistrano-rails", "~> 1.1"
  gem "capistrano-rbenv", "~> 2.1"
  gem "capistrano3-delayed-job", "~> 1.0"
  gem "capybara", "~> 3.29"
  gem "database_cleaner", "~> 1.7"
  gem "fix-db-schema-conflicts", "~> 3.0"
  gem "launchy", "~> 2.4" # For opening screenshots
  gem "pry", "~> 0.10"
  gem "pry-nav", "~> 0.2"
  gem "pry-rails", "~> 0.3"
  gem "rspec-rails", "~> 4.0"
  gem "rubocop", "0.75.0" # Should match Hound. See: http://help.houndci.com/configuration/rubocop
  gem "rubocop-rails", "2.3.2"
  gem "selenium-webdriver", "~> 3.0"
  gem "spring", "~> 1.3"
  gem "thin", "~> 1.7"
  gem "vcr", "~> 4.0"
  gem "webdrivers", "~> 4.0"
  gem "webmock", "~> 3.1"

  # Great for debugging i18n paths. Uncomment temporarily when neeeded.
  # Adds a lot of junk to the log when not needed, so only uncomment if needed.
  # gem "i18n-debug", "~> 1.1"
end

group :development do
  gem "listen", "~> 3.2"
end

group :test do
  gem "rspec-github", require: false
end
