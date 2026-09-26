class ContactInquiryMailer < ApplicationMailer
  PRODUCTION_HOSTS = %w[eggenbouwmanagement.nl www.eggenbouwmanagement.nl].freeze
  PRODUCTION_RECIPIENT = "info@eggenbouwmanagement.nl"
  STAGING_RECIPIENT = "jeggendutch@gmail.com"
  PRODUCTION_FROM = "Eggen Bouw Management <noreply@eggenbouwmanagement.nl>"
  STAGING_FROM = "Eggen Bouw Management <noreply@jeggen-dev.nl>"

  def notification(inquiry, host:)
    @inquiry = inquiry
    production = production_host?(host)

    mail(
      to: production ? PRODUCTION_RECIPIENT : STAGING_RECIPIENT,
      from: production ? PRODUCTION_FROM : STAGING_FROM,
      reply_to: inquiry.email,
      subject: "Nieuw contactformulier: #{inquiry.interest_label}"
    )
  end

  private

  def production_host?(host)
    PRODUCTION_HOSTS.include?(host.to_s.downcase)
  end
end
