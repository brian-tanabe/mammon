source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.0'

# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Used to provide AuthN
# https://github.com/heartcombo/devise
gem 'devise'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'

# Use Puma as the app server
gem 'puma', '~> 4.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.2', '>= 6.0.2.1'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'

# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'

# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

group :development do

	gem 'listen', '>= 3.0.5', '< 3.2'

	# Creates ERD diagrams
	# https://github.com/voormedia/rails-erd
	gem 'rails-erd'

	# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
	gem 'spring'
	gem 'spring-watcher-listen', '~> 2.0.0'
	# Access an interactive console on exception pages or by calling 'console' anywhere in the code.
	gem 'web-console', '>= 3.3.0'

end

group :test do

	# Adds support for Capybara system testing and selenium driver
	# https://github.com/teamcapybara/capybara
	gem 'capybara'

	# Used to create test fixtures
	# https://github.com/thoughtbot/factory_bot
	gem 'factory_bot_rails'

	# Used to create random, fake data for tests
	# https://github.com/faker-ruby/faker
	gem 'faker'

	# Adds the assigns controller testing helper back to Rails
	# https://github.com/rails/rails-controller-testing
	gem 'rails-controller-testing'

	gem 'selenium-webdriver'

	# Easy installation and use of web drivers to run system tests with browsers
	gem 'webdrivers'

end

group :development, :test do

	# Call 'byebug' anywhere in the code to stop execution and get a debugger console
	gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

	# Formats a graphical test report for use in circleci to nicely display
	# https://github.com/sj26/rspec_junit_formatter
	gem 'rspec_junit_formatter'

	# rspec is our testing framework.  Placing it in the dev will prevent generators from having to run in test mode
	# Note that rspec-rails 4.0 is still a pre release
	# https://github.com/rspec/rspec-rails
	gem 'rspec-rails', '~> 4.0.0.rc1'

	# Use sqlite3 as the database for Active Record
	# gem 'sqlite3', '~> 1.4'
	gem 'pg'

end

group :production do

	gem 'pg'

end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
