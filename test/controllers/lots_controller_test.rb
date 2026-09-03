require "test_helper"

class LotsControllerTest < ActionDispatch::IntegrationTest
  test "kavel page uses main photo for open graph image" do
    get lots_kavel_a_url
    assert_response :success
    assert_select "meta[property='og:title'][content=?]", "Kavel A · Europaweg, Coevorden"
    assert_select "meta[property='og:image'][content*='kavel_a']"
    assert_select "meta[property='og:image'][content*='main']"
  end
end
