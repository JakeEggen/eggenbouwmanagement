require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get root_url
    assert_response :success
    assert_select "html[lang=nl]"
    assert_select "meta[charset=utf-8]"
    assert_select "title", "Eggen Bouw Management in Drenthe, Overijssel en Groningen"
    assert_select "meta[name=description][content*=Groningen]"
    assert_select "link[rel=canonical][href=?]", "http://www.example.com/"
    assert_select "meta[property='og:title'][content='Eggen Bouw Management in Drenthe, Overijssel en Groningen']"
    assert_select "meta[property='og:image'][content*='home_intro_2']"
    assert_select "meta[property='og:image:alt'][content=?]", "Bouwbegeleiding op een bouwproject in Drenthe"
    assert_select "meta[property='og:description'][content*=Groningen]"
    assert_select "script[type='application/ld+json']", /Zuidwolde/
    assert_select "script[type='application/ld+json']", /62925172/
    assert_select "h1", "Bouwmanagement van plan tot oplevering"
    assert_select "h2", "Projecten"
    assert_select "figcaption", "Vechtdal College, Ommen"
    assert_select "figcaption", "RCF Renkum"
    assert_select "h2", "Ruimte om jouw eigen thuis te bouwen"
    assert_select ".home-lots__copy", /Europaweg/
    assert_select ".home-lots__sizes a[href=?]", lots_kavel_a_path, text: "Kavel A: 8.188 m²"
    assert_select ".home-lots__sizes a[href=?]", lots_kavel_b_path, text: "Kavel B: 7.126 m²"
    assert_select ".home-lots__sizes a[href=?]", lots_kavel_c_path, text: "Kavel C: 6.667 m²"
    assert_select ".home-lots a[href=?]", lots_path
    assert_select ".home-lots__actions", count: 0
    assert_select "h2", "Landbouwgrond"
    assert_select ".home-land__box", /landbouwgrond/
    assert_select ".home-lots__copy", /kavel O/
    assert_select "a[href='/kavels#Landbouwgrond']"
  end
end
