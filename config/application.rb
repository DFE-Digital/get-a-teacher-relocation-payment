# frozen_string_literal: true

require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
# require "action_cable/engine"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GetAnInternationalRelocationPayment
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults(7.0)

    config.autoload_paths << Rails.root.join("app/services")

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    config.time_zone = "London"
    config.i18n.fallbacks = true
    # config.eager_load_paths << Rails.root.join("extras")

    # Don't generate system test files.
    config.generators.system_tests = nil
    config.active_job.queue_adapter = :sidekiq

    # notify mailer
    config.action_mailer.delivery_method = :notify
    config.action_mailer.notify_settings = {
      api_key: ENV.fetch("GOVUK_NOTIFY_API_KEY"),
    }

    config.x.govuk_notify.generic_email_template_id = ENV.fetch("GOVUK_NOTIFY_GENERIC_EMAIL_TEMPLATE_ID")
    config.x.events.filtered_attributes = YAML.load_file(Rails.root.join("config/events/filtered_attributes.yml"))
    config.x.form_eligibility.contract_start_months_limit = 6
  end
end
