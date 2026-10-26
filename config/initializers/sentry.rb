# Error reporting via Sentry (EU region).
#
# The DSN is safe to commit: it only allows sending events to the project,
# not reading them. See https://docs.sentry.io/concepts/key-terms/dsn-explainer/
Sentry.init do |config|
  config.dsn = "https://f7cdb7420215c6b763587c2d5347ffbc@o4512302207926272.ingest.de.sentry.io/4512302240104528"
  config.enabled_environments = %w[production]
  config.breadcrumbs_logger = [ :active_support_logger, :http_logger ]

  # Errors only: no performance tracing or log forwarding, to stay within the free quota.
  config.traces_sample_rate = 0.0

  # Don't send visitor IPs, cookies or form data with every error.
  # Failed contact emails attach the inquiry explicitly (ContactController).
  config.send_default_pii = false

  # Malformed multipart bodies, sent by bots; Rack rejects them before the app runs.
  config.excluded_exceptions += [ "Rack::Multipart::BoundaryTooLongError" ]

  # Pick up Rails.error.report calls, not just unhandled exceptions.
  config.rails.register_error_subscriber = true

  # Render exposes the deployed commit, so events show which deploy they came from.
  config.release = ENV["RENDER_GIT_COMMIT"] if ENV["RENDER_GIT_COMMIT"].present?
end
