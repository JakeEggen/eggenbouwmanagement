class ProjectsController < ApplicationController
  CATEGORIES = [
    [ "onderhoud", "Onderhoud", "slide-1.jpg" ],
    [ "scholen", "Scholen", "vechtdal_ommen.webp" ],
    [ "verbouwingen", "Verbouwingen", "SAM_2323.jpg" ],
    [ "verzorgingstehuizen", "Verzorgingstehuizen", "home_3_lots.webp" ]
  ].freeze

  def index
    @categories = CATEGORIES.map { |key, label, _image| [ key, label ] }
    @photos = CATEGORIES.flat_map do |key, label, image|
      5.times.map do |index|
        { image: image, category: key, alt: "#{label} #{index + 1}" }
      end
    end
  end
end
