# Email delivery via Resend (https://resend.com/rails) or generic SMTP.
#
# Resend:
#   RESEND_API_KEY=re_xxxxxxxxx
# From-address is set in config/application.rb.
# The From-domain (jeggen-dev.nl) must be verified in Resend.
# Generic SMTP fallback:
#   SMTP_ADDRESS, SMTP_PORT, SMTP_USERNAME, SMTP_PASSWORD

if ENV["RESEND_API_KEY"].present?
  Rails.application.config.action_mailer.delivery_method = :smtp
  Rails.application.config.action_mailer.raise_delivery_errors = true
  Rails.application.config.action_mailer.smtp_settings = {
    address: "smtp.resend.com",
    port: 465,
    user_name: "resend",
    password: ENV["RESEND_API_KEY"],
    tls: true
  }
  Rails.logger.info("[mailer] Resend SMTP enabled") if defined?(Rails.logger)
elsif ENV["SMTP_ADDRESS"].present?
  Rails.application.config.action_mailer.delivery_method = :smtp
  Rails.application.config.action_mailer.raise_delivery_errors = true
  Rails.application.config.action_mailer.smtp_settings = {
    address: ENV["SMTP_ADDRESS"],
    port: ENV.fetch("SMTP_PORT", 587).to_i,
    user_name: ENV["SMTP_USERNAME"],
    password: ENV["SMTP_PASSWORD"],
    authentication: :plain,
    enable_starttls_auto: true
  }
end
