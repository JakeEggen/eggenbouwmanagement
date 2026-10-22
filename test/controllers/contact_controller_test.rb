require "test_helper"

class ContactControllerTest < ActionDispatch::IntegrationTest
  # Delivery method that fails the first `failures` times with `error`.
  class FlakyDelivery
    cattr_accessor :error, :failures, :calls

    def initialize(_settings) = nil

    def deliver!(mail)
      self.class.calls += 1
      raise error if calls <= failures
      ActionMailer::Base.deliveries << mail
    end
  end

  ActionMailer::Base.add_delivery_method :flaky, FlakyDelivery

  VALID_PARAMS = {
    contact_inquiry: {
      name: "Jake Eggen",
      email: "jake@example.com",
      interest: "vraag",
      message: "Hallo"
    }
  }.freeze

  def with_flaky_delivery(error:, failures:)
    FlakyDelivery.error = error
    FlakyDelivery.failures = failures
    FlakyDelivery.calls = 0
    previous_method = ActionMailer::Base.delivery_method
    previous_delay = ContactController.delivery_retry_delay
    ActionMailer::Base.delivery_method = :flaky
    ContactController.delivery_retry_delay = 0
    yield
  ensure
    ActionMailer::Base.delivery_method = previous_method
    ContactController.delivery_retry_delay = previous_delay
  end

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

  test "emails the staging address off the production site" do
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

    assert_redirected_to contact_path

    email = ActionMailer::Base.deliveries.last
    assert_equal [ "jeggendutch@gmail.com" ], email.to
    assert_equal [ "noreply@jeggen-dev.nl" ], email.from
    assert_equal [ "jake@example.com" ], email.reply_to
    assert_includes email.subject, "Landbouwgrond"
    assert_includes email.text_part.body.to_s, "62925172"
  end

  test "retries a transient delivery failure and then succeeds" do
    with_flaky_delivery(error: Net::ReadTimeout.new, failures: 2) do
      post contact_url, params: VALID_PARAMS
    end

    assert_equal 3, FlakyDelivery.calls
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_redirected_to contact_path
  end

  test "shows an error and keeps the input when delivery keeps failing" do
    with_flaky_delivery(error: Net::OpenTimeout.new, failures: Float::INFINITY) do
      post contact_url, params: VALID_PARAMS
    end

    assert_equal ContactController::DELIVERY_ATTEMPTS, FlakyDelivery.calls
    assert_response :service_unavailable
    assert_select ".contact-form__errors", /niet worden verzonden/
    assert_select "input#contact_inquiry_name[value=?]", "Jake Eggen"
    assert_select "textarea#contact_inquiry_message", "Hallo"
  end

  test "does not retry a permanent delivery failure" do
    with_flaky_delivery(error: Net::SMTPAuthenticationError.new("535 Invalid API key"), failures: Float::INFINITY) do
      post contact_url, params: VALID_PARAMS
    end

    assert_equal 1, FlakyDelivery.calls
    assert_response :service_unavailable
    assert_select ".contact-form__errors", /niet worden verzonden/
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

    email = ActionMailer::Base.deliveries.last
    assert_equal [ "info@eggenbouwmanagement.nl" ], email.to
    assert_equal [ "noreply@eggenbouwmanagement.nl" ], email.from
  end

  test "ignores bot submissions that fill the honeypot" do
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

    assert_redirected_to contact_path
  end

  test "does not send when required fields are missing" do
    assert_no_emails do
      post contact_url, params: { contact_inquiry: { name: "" } }
    end
    assert_response :unprocessable_entity
  end
end
