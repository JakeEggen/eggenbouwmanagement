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
      {
        image: variant_path(file, "large"),
        thumb: variant_path(file, "thumbs"),
        category: key,
        alt: "#{label} #{file[/\A(\d+)/]}"
      }
    end
  end

  private

  def project_images
    image_dir = Rails.root.join("app/assets/images/projects")

    Dir.children(image_dir)
       .select { |file| file.match?(/\.(jpg|jpeg|png|webp)\z/i) }
       .sort_by { |file| [ file[/\A(\d+)/].to_i, file ] }
  end

  def variant_path(file, folder)
    name = "#{File.basename(file, '.*')}.jpg"
    variant = Rails.root.join("app/assets/images/projects", folder, name)
    variant.file? ? "projects/#{folder}/#{name}" : "projects/#{file}"
  end
end
