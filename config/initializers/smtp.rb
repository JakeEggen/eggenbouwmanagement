# Email delivery via Resend (https://resend.com/rails) or generic SMTP.
#
# Resend:
#   RESEND_API_KEY=re_xxxxxxxxx
#   MAILER_FROM=Eggen Bouw Management <noreply@eggenbouwmanagement.nl>
#
# The From-domain must be verified in Resend. Until then you can test with
#   MAILER_FROM=Eggen Bouw Management <onboarding@resend.dev>
#
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
