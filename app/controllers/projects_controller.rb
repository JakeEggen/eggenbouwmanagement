class ProjectsController < ApplicationController
  CATEGORY_IMAGES = {
    "verzorging" => %w[1_0740-impressie-vogelvlucht 12_Maartenshof-150 13_SAM_2316],
    "sport" => %w[2_IMG_2101],
    "school" => %w[3_SAM_2309 4_SAM_23141 5_SAM_2327 14_SAM_2310 15_SAM_2313],
    "woningbouw" => %w[6_SAM_2333 7_SAM_2328 8_SAM_2323 9_SAM_2320 10_P6300449 16_SAM_2306 17_SAM_2307 18_SAM_2302],
    "winkel" => %w[11_Maartenshof-176],
    "onderhoud" => %w[19_Wijert]
  }.freeze

  CATEGORY_LABELS = {
    "verzorging" => "Verzorging",
    "sport" => "Sport",
    "school" => "School",
    "woningbouw" => "Woningbouw",
    "winkel" => "Winkel",
    "onderhoud" => "Onderhoud"
  }.freeze

  def index
    @categories = CATEGORY_LABELS
    categories_by_image = CATEGORY_IMAGES.each_with_object({}) do |(category, names), map|
      names.each { |name| map[name] = category }
    end

    @photos = project_images.map do |file|
      key = categories_by_image[File.basename(file, ".*")]
      label = CATEGORY_LABELS[key]
      {
        image: variant_path(file, "large"),
        thumb: variant_path(file, "thumbs"),
        category: key,
        alt: [ label, file[/\A(\d+)/] ].compact.join(" ")
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
