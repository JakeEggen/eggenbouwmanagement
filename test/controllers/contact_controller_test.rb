require "test_helper"

class ContactControllerTest < ActionDispatch::IntegrationTest
  test "should get contact" do
    get contact_url
    assert_response :success
    assert_select "h1", "Contact"
    assert_select "form"
    assert_select "input#contact_inquiry_kvk_number"
    assert_select "a[href=?]", privacy_path
  end

  test "preselects interest from query param" do
    get contact_url, params: { interesse: "kavel_b" }
    assert_select "select#contact_inquiry_interest option[value=kavel_b][selected]"
  end

  test "creates inquiry and emails the staging address off the production site" do
    assert_difference("ContactInquiry.count", 1) do
      assert_emails 1 do
        post contact_url, params: {
          contact_inquiry: {
            company_name: "Eggen",
            kvk_number: "62925172",
            name: "Jake Eggen",
            email: "jake@example.com",
            interest: "landbouwgrond",
            message: "Hallo"
          }
        }
      end
    end

    assert_redirected_to contact_path
    inquiry = ContactInquiry.last
    assert_equal "landbouwgrond", inquiry.interest
    assert_equal "jake@example.com", inquiry.email
    assert_equal "62925172", inquiry.kvk_number

    email = ActionMailer::Base.deliveries.last
    assert_equal [ "jeggendutch@gmail.com" ], email.to
    assert_includes email.subject, "Landbouwgrond"
  end

  test "emails the production address when submitted on the production site" do
    host! "www.eggenbouwmanagement.nl"

    assert_emails 1 do
      post contact_url, params: {
        contact_inquiry: {
          name: "Jake Eggen",
          email: "jake@example.com",
          interest: "vraag"
        }
      }
    end

    assert_equal [ "info@eggenbouwmanagement.nl" ], ActionMailer::Base.deliveries.last.to
  end

  test "ignores bot submissions that fill the honeypot" do
    assert_no_difference("ContactInquiry.count") do
      assert_no_emails do
        post contact_url, params: {
          contact_inquiry: {
            company_name: "Spam",
            name: "Bot",
            email: "bot@example.com",
            interest: "overig",
            website: "https://spam.example"
          }
        }
      end
    end

    assert_redirected_to contact_path
  end

  test "does not create inquiry when required fields are missing" do
    assert_no_difference("ContactInquiry.count") do
      assert_no_emails do
        post contact_url, params: { contact_inquiry: { name: "" } }
      end
    end
    assert_response :unprocessable_entity
  end
end
