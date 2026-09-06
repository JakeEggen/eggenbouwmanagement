class ContactInquiryMailer < ApplicationMailer
  default to: "jeggendutch@gmail.com"

  def notification(inquiry)
    @inquiry = inquiry

    mail(
      reply_to: inquiry.email,
      subject: "Nieuw contactformulier: #{inquiry.interest_label}"
    )
  end
end
