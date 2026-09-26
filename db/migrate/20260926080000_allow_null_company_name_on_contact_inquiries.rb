class AllowNullCompanyNameOnContactInquiries < ActiveRecord::Migration[8.0]
  def change
    change_column_null :contact_inquiries, :company_name, true
  end
end
