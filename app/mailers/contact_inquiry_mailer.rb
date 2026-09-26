class ContactInquiryMailer < ApplicationMailer
  PRODUCTION_HOSTS = %w[eggenbouwmanagement.nl www.eggenbouwmanagement.nl].freeze
  PRODUCTION_RECIPIENT = "info@eggenbouwmanagement.nl"
  STAGING_RECIPIENT = "jeggendutch@gmail.com"

  def notification(inquiry, host:)
    @inquiry = inquiry

    mail(
      to: recipient_for(host),
      reply_to: inquiry.email,
      subject: "Nieuw contactformulier: #{inquiry.interest_label}"
    )
  end

  private

  def recipient_for(host)
    if PRODUCTION_HOSTS.include?(host.to_s.downcase)
      PRODUCTION_RECIPIENT
    else
      STAGING_RECIPIENT
    end
  end
end
