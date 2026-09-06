namespace :images do
  desc "Generate smaller project photos for the grid (thumbs) and lightbox (large)"
  task project_variants: :environment do
    generate_variants(
      Rails.root.join("app/assets/images/projects"),
      "thumbs" => 800,
      "large" => 1920
    )
  end

  desc "Generate thumbnails for kavel galleries"
  task lot_thumbs: :environment do
    %w[kavel_a kavel_b kavel_c].each do |folder|
      generate_variants(
        Rails.root.join("app/assets/images", folder),
        "thumbs" => 800
      )
    end
  end

  def generate_variants(source_dir, variants)
    variants.each do |folder, max_edge|
      output_dir = source_dir.join(folder)
      FileUtils.mkdir_p(output_dir)

      Dir.children(source_dir).each do |file|
        next unless file.match?(/\.(jpg|jpeg|png|webp)\z/i)

        source = source_dir.join(file)
        next unless source.file?

        dest = output_dir.join("#{File.basename(file, '.*')}.jpg")
        ok = system(
          "sips", "-Z", max_edge.to_s,
          "-s", "format", "jpeg",
          "-s", "formatOptions", "78",
          source.to_s,
          "--out", dest.to_s,
          out: File::NULL,
          err: File::NULL
        )
        raise "sips failed for #{file}" unless ok

        puts "#{source_dir.basename}/#{folder}/#{dest.basename} (#{dest.size / 1024} KB)"
      end
    end
  end
end
