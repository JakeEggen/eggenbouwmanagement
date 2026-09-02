class ContactController < ApplicationController
  def contact
    @contact_inquiry = ContactInquiry.new(interest: params[:interesse])
  end

  def create
    @contact_inquiry = ContactInquiry.new(contact_inquiry_params)

    if @contact_inquiry.save
      deliver_notification
      redirect_to contact_path, notice: "Bedankt. Ik neem z.s.m. contact met u op."
    else
      render :contact, status: :unprocessable_entity
    end
  end

  private

  def contact_inquiry_params
    params.require(:contact_inquiry).permit(
      :company_name, :name, :address, :postal_code, :city, :phone, :email, :message, :interest
    )
  end

  def deliver_notification
    ContactInquiryMailer.notification(@contact_inquiry).deliver_now
  rescue StandardError => e
    Rails.logger.error("Contact inquiry email failed (id=#{@contact_inquiry.id}): #{e.class}: #{e.message}")
  end
end
