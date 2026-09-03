require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get privacy statement" do
    get privacy_url
    assert_response :success
    assert_select "h1", "Privacyverklaring"
    assert_select "a[href='mailto:info@eggenbouwmanagement.nl']"
  end
end
