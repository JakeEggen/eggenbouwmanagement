require "test_helper"

class LotsControllerTest < ActionDispatch::IntegrationTest
  test "kavel page uses main photo for open graph image" do
    get lots_kavel_a_url
    assert_equal "/kavels/bouwgrond-europaweg-a", lots_kavel_a_path
    assert_response :success
    assert_select "meta[property='og:title'][content=?]", "Kavel A · Europaweg, Coevorden"
    assert_select "meta[property='og:image'][content*='kavel_a']"
    assert_select "meta[property='og:image'][content*='main']"
  end

  test "kavels index has original location and plan copy" do
    get lots_url
    assert_response :success
    assert_select "h1", "Bouwkavels in Coevorden"
    assert_select "h2", "Zelf bouwen"
    assert_select "h2", "Extra grond"
    assert_select "meta[property='og:title'][content='Bouwkavels Europaweg, Coevorden']"
    assert_select ".lots-index__copy", /Klinkenvlier/
    assert_select ".lots-index__copy a[href='https://zoek.officielebekendmakingen.nl/gmb-2024-193992.html']", /Europaweg 8/
    assert_select "#Landbouwgrond h2", "Landbouwgrond"
    assert_select "#Landbouwgrond", /19.175 m²/
    assert_select "#Landbouwgrond img[src*='landbouwgrond']"
    assert_select "#Landbouwgrond a[href=?]", contact_path(interesse: "landbouwgrond")
  end

  test "old english lot urls redirect to dutch slugs" do
    get "/lots/kavel_b"
    assert_redirected_to "/kavels/bouwgrond-europaweg-b"
  end
end
