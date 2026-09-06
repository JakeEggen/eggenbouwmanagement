require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get root_url
    assert_response :success
    assert_select "meta[property='og:title'][content='Bouwmanagement in Drenthe, Overijssel en Groningen']"
    assert_select "meta[property='og:image']"
    assert_select "meta[property='og:description'][content*=Groningen]"
    assert_select "h1", "Bouwmanagement van plan tot oplevering"
    assert_select "h2", "Projecten"
    assert_select "figcaption", "Vechtdal College, Ommen"
    assert_select "figcaption", "RCF Renkum"
    assert_select "h2", "Kavels"
    assert_select ".home-lots__text", /Europaweg/
    assert_select ".home-lots a[href=?]", lots_path
    assert_select "h2", "Landbouwgrond"
    assert_select ".home-land__box", /landbouwgrond/
    assert_select ".home-lots__text", /kavel O/
    assert_select "a[href='/kavels#Landbouwgrond']"
  end
end
