require "net/smtp"

class ContactController < ApplicationController
  DELIVERY_ATTEMPTS = 3

  # Network hiccups and SMTP 4xx replies are worth retrying; anything else
  # (bad credentials, rejected sender, 5xx) will fail the same way again.
  TRANSIENT_DELIVERY_ERRORS = [
    Net::OpenTimeout, Net::ReadTimeout, Net::SMTPServerBusy,
    Errno::ECONNREFUSED, Errno::ECONNRESET, Errno::EHOSTUNREACH,
    SocketError, IOError, OpenSSL::SSL::SSLError
  ].freeze

  # Seconds to wait before retry n is `delivery_retry_delay * n`.
  class_attribute :delivery_retry_delay, default: 1

  def contact
    @contact_inquiry = ContactInquiry.new(interest: params[:interesse])
  end

  def create
    if honeypot_filled?
      redirect_to contact_path, notice: "Bedankt. Ik neem z.s.m. contact met u op."
      return
    end

    @contact_inquiry = ContactInquiry.new(contact_inquiry_params)

    unless @contact_inquiry.valid?
      render :contact, status: :unprocessable_entity
      return
    end

    if deliver_notification
      redirect_to contact_path, notice: "Bedankt. Ik neem z.s.m. contact met u op."
    else
      @delivery_failed = true
      render :contact, status: :service_unavailable
    end
  end

  private

  def honeypot_filled?
    params.dig(:contact_inquiry, :website).present?
  end

  def contact_inquiry_params
    params.require(:contact_inquiry).permit(
      :company_name, :kvk_number, :name, :address, :postal_code, :city, :phone, :email, :message, :interest
    )
  end

  def deliver_notification
    attempt = 0
    begin
      attempt += 1
      ContactInquiryMailer.notification(@contact_inquiry, host: request.host).deliver_now
      true
    rescue *TRANSIENT_DELIVERY_ERRORS => e
      if attempt < DELIVERY_ATTEMPTS
        Rails.logger.warn("Contact inquiry email attempt #{attempt} failed, retrying: #{e.class}: #{e.message}")
        sleep(delivery_retry_delay * attempt)
        retry
      end
      log_failed_delivery(e)
      false
    rescue StandardError => e
      log_failed_delivery(e)
      false
    end
  end

  # Last-resort record of the inquiry so it can be recovered from the logs.
  def log_failed_delivery(error)
    Rails.logger.error(
      "Contact inquiry email failed: #{error.class}: #{error.message} " \
      "inquiry=#{@contact_inquiry.attributes.to_json}"
    )
  end
end
