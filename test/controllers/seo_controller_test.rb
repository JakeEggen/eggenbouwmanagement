require "test_helper"

class SeoControllerTest < ActionDispatch::IntegrationTest
  test "production robots allows crawling and points at the sitemap" do
    host! "www.eggenbouwmanagement.nl"
    get "/robots.txt"

    assert_response :success
    assert_equal "text/plain", response.media_type
    assert_includes response.body, "User-agent: *\n"
    assert_includes response.body, "Allow: /\n"
    assert_includes response.body, "Disallow: /up\n"
    assert_includes response.body, "Sitemap: https://www.eggenbouwmanagement.nl/sitemap.xml\n"
  end

  test "apex host uses the www sitemap url" do
    host! "eggenbouwmanagement.nl"
    get "/robots.txt"

    assert_includes response.body, "Sitemap: https://www.eggenbouwmanagement.nl/sitemap.xml\n"
  end

  test "non-production robots blocks crawling" do
    get "/robots.txt"

    assert_response :success
    assert_equal "User-agent: *\nDisallow: /\n", response.body
  end

  test "sitemap lists the public pages on the canonical host" do
    host! "eggenbouwmanagement.nl"
    get "/sitemap.xml"

    assert_response :success
    assert_equal "application/xml", response.media_type
    assert_includes response.body, "<loc>https://www.eggenbouwmanagement.nl/</loc>"
    assert_includes response.body, "<loc>https://www.eggenbouwmanagement.nl/projecten</loc>"
    assert_includes response.body, "<loc>https://www.eggenbouwmanagement.nl/kavels</loc>"
    assert_includes response.body, "<loc>https://www.eggenbouwmanagement.nl/kavels/bouwgrond-europaweg-a</loc>"
    assert_includes response.body, "<loc>https://www.eggenbouwmanagement.nl/kavels/bouwgrond-europaweg-b</loc>"
    assert_includes response.body, "<loc>https://www.eggenbouwmanagement.nl/kavels/bouwgrond-europaweg-c</loc>"
    assert_includes response.body, "<loc>https://www.eggenbouwmanagement.nl/contact</loc>"
    assert_includes response.body, "<loc>https://www.eggenbouwmanagement.nl/privacyverklaring</loc>"
    assert_not_includes response.body, "/up"
    assert_not_includes response.body, "/lots"
  end

  test "production pages use a canonical url without the query string" do
    host! "www.eggenbouwmanagement.nl"
    get "/contact?interesse=landbouwgrond"

    assert_select "link[rel=canonical][href=?]", "https://www.eggenbouwmanagement.nl/contact"
    assert_select "meta[property='og:url'][content=?]", "https://www.eggenbouwmanagement.nl/contact"
    assert_select "meta[name=robots]", count: 0
    assert_select "html[lang=nl]"
    assert_select "meta[charset=utf-8]"
  end

  test "non-production pages are noindex" do
    get root_url

    assert_select "meta[name=robots][content=?]", "noindex, nofollow"
    assert_select "link[rel=canonical][href=?]", "http://www.example.com/"
  end
end
