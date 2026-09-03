class ProjectsController < ApplicationController
  CATEGORIES = [
    [ "onderhoud", "Onderhoud" ],
    [ "scholen", "Scholen" ],
    [ "verbouwingen", "Verbouwingen" ],
    [ "verzorgingstehuizen", "Verzorgingstehuizen" ]
  ].freeze

  def index
    @categories = CATEGORIES

    @photos = project_images.each_with_index.map do |file, index|
      key, label = CATEGORIES[index / 5] || CATEGORIES.last
      { image: "projects/#{file}", category: key, alt: "#{label} #{file[/\A(\d+)/]}" }
    end
  end

  private

  def project_images
    image_dir = Rails.root.join("app/assets/images/projects")

    Dir.children(image_dir)
       .select { |file| file.match?(/\.(jpg|jpeg|png|webp)\z/i) }
       .sort_by { |file| [ file[/\A(\d+)/].to_i, file ] }
  end
end
