module ApplicationHelper
  SITE_NAME = "Eggen Bouw Management"
  SITE_DESCRIPTION = "Bouwmanagement, bouwbegeleiding en bouwadvies in Drenthe, Overijssel en Groningen. Eggen Bouw Management begeleidt nieuwbouw en verbouw van plan tot oplevering."

  def field_class(record, attribute, base: "form-control")
    [ base, ("is-invalid" if record.errors[attribute].any?) ].compact.join(" ")
  end

  def page_title
    title = content_for(:title)
    title.present? ? "#{title.strip} · #{SITE_NAME}" : SITE_NAME
  end

  def og_title
    content_for(:og_title).presence&.strip || content_for(:title).presence&.strip || SITE_NAME
  end

  def og_description
    content_for(:og_description).presence&.strip || SITE_DESCRIPTION
  end

  def og_image_url
    source = content_for(:og_image).presence&.strip || "slide-1.jpg"
    absolute_asset_url(source)
  end

  def og_url
    request.original_url.split("#").first
  end

  def absolute_asset_url(source)
    return source if source.start_with?("http://", "https://")

    path = path_to_asset(source)
    return path if path.start_with?("http://", "https://")

    "#{request.base_url}#{path}"
  end
end
