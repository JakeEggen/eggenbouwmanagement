class ContactInquiry
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :company_name, :string
  attribute :kvk_number, :string
  attribute :name, :string
  attribute :address, :string
  attribute :postal_code, :string
  attribute :city, :string
  attribute :phone, :string
  attribute :email, :string
  attribute :message, :string
  attribute :interest, :string

  attr_accessor :website

  INTERESTS = {
    "kavel_a" => "Kavel A",
    "kavel_b" => "Kavel B",
    "kavel_c" => "Kavel C",
    "landbouwgrond" => "Landbouwgrond",
    "vraag" => "Vraag",
    "overig" => "Overig"
  }.freeze

  validates :name, :email, :interest, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :interest, inclusion: { in: INTERESTS.keys }

  def interest_label
    INTERESTS[interest] || interest
  end
end
