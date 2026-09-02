class ContactInquiry < ApplicationRecord
  INTERESTS = {
    "kavel_a" => "Kavel A",
    "kavel_b" => "Kavel B",
    "kavel_c" => "Kavel C",
    "landbouwgrond" => "Landbouwgrond",
    "vraag" => "Vraag",
    "overig" => "Overig"
  }.freeze

  validates :company_name, :name, :email, :interest, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :interest, inclusion: { in: INTERESTS.keys }

  def interest_label
    INTERESTS[interest] || interest
  end
end
