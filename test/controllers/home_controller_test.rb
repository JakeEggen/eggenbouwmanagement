require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get root_url
    assert_response :success
    assert_select "meta[property='og:title'][content='Eggen Bouw Management']"
    assert_select "meta[property='og:image']"
    assert_select "meta[property='og:description']"
  end
end
