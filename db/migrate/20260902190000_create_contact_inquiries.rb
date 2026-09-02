class CreateContactInquiries < ActiveRecord::Migration[8.0]
  def change
    create_table :contact_inquiries do |t|
      t.string :company_name, null: false
      t.string :name, null: false
      t.string :address
      t.string :postal_code
      t.string :city
      t.string :phone
      t.string :email, null: false
      t.text :message
      t.string :interest, null: false

      t.timestamps
    end
  end
end
