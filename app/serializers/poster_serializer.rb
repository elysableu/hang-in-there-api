class PosterSerializer
  def self.format_posters(posters)
    {
      data: posters.map do |poster|
        formatter(poster)
      end
    }
  end

  def self.formatter(poster)
    {
      id: poster.id,
      type: "poster",
      attributes: {
        name: poster.name,
        description: poster.description,
        price: format("%.3f", poster.price).to_f,
        year: poster.year,
        vintage: poster.vintage,
        img_url: poster.img_url,
      }
    }
  end
end