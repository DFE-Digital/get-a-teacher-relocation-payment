Sentry.init do |config|
  config.dsn = ENV.fetch("SENTRY_DSN", nil)
  config.enabled_environments = %w[production staging qa]

  config.traces_sample_rate = 0.1

  config.transport.ssl_verification = true if Rails.env.production?
end
