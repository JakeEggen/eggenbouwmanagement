require "test_helper"

class ContactInquiryTest < ActiveSupport::TestCase
  def valid_attrs
    {
      company_name: "Eggen",
      name: "Jake Eggen",
      email: "jake@example.com",
      interest: "kavel_a"
    }
  end

  test "is valid with required fields" do
    assert ContactInquiry.new(valid_attrs).valid?
  end

  test "requires company name, name, email and interest" do
    inquiry = ContactInquiry.new
    assert_not inquiry.valid?
    assert_includes inquiry.errors.attribute_names, :company_name
    assert_includes inquiry.errors.attribute_names, :name
    assert_includes inquiry.errors.attribute_names, :email
    assert_includes inquiry.errors.attribute_names, :interest
  end

  test "rejects unknown interest" do
    inquiry = ContactInquiry.new(valid_attrs.merge(interest: "onbekend"))
    assert_not inquiry.valid?
    assert_includes inquiry.errors.attribute_names, :interest
  end
end
