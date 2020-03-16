source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.0'

gem 'rails', '~> 5.2.3'
gem 'bootstrap-sass', '3.3.7'
gem 'bcrypt',         '3.1.12'
gem 'faker',          '1.7.3'
gem 'will_paginate',           '3.1.7'
gem 'bootstrap-will_paginate', '1.0.0'
gem 'sqlite3', '~> 1.3.6', group: :development
gem 'puma', '~> 3.11'
gem 'sass-rails', '~> 5.0'
gem 'rails_12factor', group: :production
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem "whenever", require: false
gem 'jbuilder', '~> 2.5'
gem "jquery-rails"
gem 'bootstrap', '~> 4.1.1'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'line_notify'
group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem "better_errors"
  gem "binding_of_caller"
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'chromedriver-helper'
  gem 'rails-controller-testing'
end

group :production do
  gem 'pg', '0.20.0'
end
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
