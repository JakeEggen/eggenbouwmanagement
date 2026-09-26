class AddKvkNumberToContactInquiries < ActiveRecord::Migration[8.0]
  def change
    add_column :contact_inquiries, :kvk_number, :string
  end
end
