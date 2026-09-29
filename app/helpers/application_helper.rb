module ApplicationHelper
  SITE_NAME = "Eggen Bouw Management"
  SITE_DESCRIPTION = "Bouwmanagement, bouwbegeleiding en bouwadvies in Drenthe, Overijssel en Groningen. Eggen Bouw Management begeleidt nieuwbouw en verbouw van plan tot oplevering."
  PRODUCTION_HOSTS = %w[eggenbouwmanagement.nl www.eggenbouwmanagement.nl].freeze
  CANONICAL_HOST = "www.eggenbouwmanagement.nl"
  DEFAULT_OG_IMAGE = "home_intro_2.png"
  BESTEMMINGSPLAN_EUROPAWEG_URL = "https://zoek.officielebekendmakingen.nl/gmb-2024-193992.html"

  def self.canonical_origin_for(request)
    if PRODUCTION_HOSTS.include?(request.host)
      "https://#{CANONICAL_HOST}"
    else
      request.base_url
    end
  end

  def bestemmingsplan_europaweg_link(text = "bestemmingsplan Europaweg 8 te Coevorden")
    link_to text, BESTEMMINGSPLAN_EUROPAWEG_URL, target: "_blank", rel: "noreferrer"
  end

  def field_class(record, attribute, base: "form-control")
    [ base, ("is-invalid" if record.errors[attribute].any?) ].compact.join(" ")
  end

  def page_title
    title = content_for(:title).to_s.strip
    return SITE_NAME if title.blank?
    return title if title.include?(SITE_NAME)

    "#{title} · #{SITE_NAME}"
  end

  def og_title
    content_for(:og_title).presence&.strip || content_for(:title).presence&.strip || SITE_NAME
  end

  def og_description
    content_for(:og_description).presence&.strip || SITE_DESCRIPTION
  end

  def og_image_url
    absolute_asset_url(content_for(:og_image).presence&.strip || DEFAULT_OG_IMAGE)
  end

  def og_image_alt
    content_for(:og_image_alt).presence&.strip || og_title
  end

  def canonical_origin
    ApplicationHelper.canonical_origin_for(request)
  end

  def canonical_url
    "#{canonical_origin}#{request.path}"
  end

  def indexable_request?
    PRODUCTION_HOSTS.include?(request.host)
  end

  def absolute_asset_url(source)
    return source if source.start_with?("http://", "https://")

    path = path_to_asset(source)
    return path if path.start_with?("http://", "https://")

    "#{canonical_origin}#{path}"
  end

  def organization_json_ld
    {
      "@context" => "https://schema.org",
      "@type" => "ProfessionalService",
      "@id" => "#{canonical_origin}/#organization",
      "name" => SITE_NAME,
      "url" => "#{canonical_origin}/",
      "logo" => absolute_asset_url("logo.jpg"),
      "image" => absolute_asset_url(DEFAULT_OG_IMAGE),
      "email" => "info@eggenbouwmanagement.nl",
      "telephone" => "+31627263145",
      "address" => {
        "@type" => "PostalAddress",
        "streetAddress" => "Schottershuizen 21",
        "postalCode" => "7921 TJ",
        "addressLocality" => "Zuidwolde",
        "addressCountry" => "NL"
      },
      "areaServed" => [ "Drenthe", "Overijssel", "Groningen" ],
      "identifier" => {
        "@type" => "PropertyValue",
        "name" => "KvK",
        "value" => "62925172"
      }
    }
  end
end
