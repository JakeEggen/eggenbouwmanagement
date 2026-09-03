class LotsController < ApplicationController
  KAVELS = [
    {
      folder: "kavel_a",
      name: "Kavel A",
      address: "Europaweg A",
      size: "8.188 m²",
      price: "€ 360.000 k.k.",
      alt: "Bouwkavel A aan de Europaweg in Coevorden"
    },
    {
      folder: "kavel_b",
      name: "Kavel B",
      address: "Europaweg B",
      size: "7.126 m²",
      price: "€ 390.000 k.k.",
      alt: "Bouwkavel B aan de Europaweg in Coevorden"
    },
    {
      folder: "kavel_c",
      name: "Kavel C",
      address: "Europaweg C",
      size: "6.667 m²",
      price: "€ 405.000 k.k.",
      alt: "Bouwkavel C aan de Europaweg in Coevorden"
    }
  ].freeze

  def index
    @lots = KAVELS.map do |kavel|
      kavel.merge(
        path: public_send("lots_#{kavel[:folder]}_path"),
        image: main_photo(kavel[:folder])
      )
    end
  end

  def kavel_a
    load_photos("kavel_a")
  end

  def kavel_b
    load_photos("kavel_b")
  end

  def kavel_c
    load_photos("kavel_c")
  end

  private

  def load_photos(folder)
    kavel = KAVELS.find { |item| item[:folder] == folder }
    @photos = photos_for(folder, kavel[:alt])
  end

  def photos_for(folder, alt)
    image_files(folder).map.with_index(1) do |file, index|
      { file: "#{folder}/#{file}", alt: index == 1 ? alt : "#{alt} #{index}" }
    end
  end

  def main_photo(folder)
    file = image_files(folder).first
    file && "#{folder}/#{file}"
  end

  def image_files(folder)
    dir = Rails.root.join("app/assets/images", folder)
    return [] unless dir.directory?

    files = Dir.children(dir).select { |name| name.match?(/\.(jpg|jpeg|png|webp|avif)\z/i) }
    mains = files.select { |name| name.match?(/main/i) }
    rest = files.reject { |name| name.match?(/main/i) }
                .sort_by { |name| [ name[/\A(\d+)/].to_i, name ] }
    mains.sort + rest
  end
end
