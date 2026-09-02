class LotsController < ApplicationController
  def index
    @lots = [
      {
        name: "Kavel A",
        address: "Europaweg A",
        size: "8.188 m²",
        price: "€ 360.000 k.k.",
        path: lots_kavel_a_path
      },
      {
        name: "Kavel B",
        address: "Europaweg B",
        size: "7.126 m²",
        price: "€ 390.000 k.k.",
        path: lots_kavel_b_path
      },
      {
        name: "Kavel C",
        address: "Europaweg C",
        size: "6.667 m²",
        price: "€ 405.000 k.k.",
        path: lots_kavel_c_path
      }
    ]
  end

  def kavel_a; end
  def kavel_b; end
  def kavel_c; end
end
