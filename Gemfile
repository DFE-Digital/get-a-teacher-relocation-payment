# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.3"

gem "actiontext", ">= 7.1.3.3"
gem "bootsnap", require: false
gem "foreman"
gem "jbuilder"
gem "okcomputer"
gem "pg", "~> 1.5"
gem "puma", ">= 6.4.2", "< 7"
gem "rails", "~> 7.1.4"
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

gem "pagy"
gem "scenic"

###############
# GOVUK GEMS ##
###############
# Used to build our forms and style them using govuk-frontend class names
gem "govuk-components", "4.1.2"
gem "govuk_design_system_formbuilder"
gem "notifications-ruby-client"
# UK postcode parsing and validation for Ruby
gem "uk_postcode"
# Phone number validations: https://design-system.service.gov.uk/patterns/telephone-numbers/
gem "phonelib"
###############

gem "amazing_print"
gem "audited", "~> 5.4"
gem "concurrent-ruby", require: "concurrent"
gem "concurrent-ruby-ext"
gem "config", "~> 5.1"
gem "devise", "~> 4.9"
gem "flipper"
gem "flipper-active_record"
gem "flipper-ui"
gem "httparty", "~> 0.21"
gem "invisible_captcha"
gem "omniauth-azure-activedirectory-v2"
gem "rails_semantic_logger"
gem "rolify"
gem "sentry-rails", "~> 5.17"

group :test do
  gem "shoulda-matchers", "~> 6.2"
  gem "simplecov", require: false
end
gem "factory_bot_rails"
gem "faker"

group :development, :test do
  gem "rubocop-govuk", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails"
  gem "rubocop-rspec"

  # Debugging
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "pry-byebug"

  # Better use of test helpers such as save_and_open_page/screenshot
  gem "launchy"

  # Testing framework
  gem "brakeman"
  gem "bundler-audit"
  gem "capybara"
  gem "dotenv-rails"
  gem "rspec-rails"
end

group :development do
  gem "annotate"
  gem "binding_of_caller"
  gem "web-console"
end

# WARNING
# only update the sidekiq gem when the available azure redis version is 7.x or above
gem "sidekiq", "~> 6.5" # /!\ sidekiq version 7 has dropped support for redis version 6 which is the latest redis version on azure.

gem "sidekiq-cron", "~> 1.12"

gem "mail-notify", "~> 1.2"

gem "dartsass-rails", "~> 0.5.0"

gem "importmap-rails", "~> 1.2"

gem "propshaft", "~> 0.8.0"

gem "rubyXL", "~> 3.4"
