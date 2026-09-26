class SeoController < ApplicationController
  def robots
    render plain: robots_body, content_type: "text/plain; charset=utf-8"
  end

  def sitemap
    origin = ApplicationHelper.canonical_origin_for(request)
    @urls = [
      root_path,
      projects_path,
      lots_path,
      lots_kavel_a_path,
      lots_kavel_b_path,
      lots_kavel_c_path,
      contact_path,
      privacy_path
    ].map { |path| "#{origin}#{path}" }

    render layout: false, content_type: "application/xml; charset=utf-8"
  end

  private

  def robots_body
    if ApplicationHelper::PRODUCTION_HOSTS.include?(request.host)
      <<~TEXT
        User-agent: *
        Allow: /
        Disallow: /up

        Sitemap: #{ApplicationHelper.canonical_origin_for(request)}/sitemap.xml
      TEXT
    else
      <<~TEXT
        User-agent: *
        Disallow: /
      TEXT
    end
  end
end
