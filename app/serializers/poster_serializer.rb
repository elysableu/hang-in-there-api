class PosterSerializer
  def self.format_posters(posters)
    {
      data: posters.map do |poster|
        formatter(poster) # Calls the formatter method for each poster
      end
    }
  end

  def self.formatter(poster)
    {
      id: poster.id.to_s,
      type: "poster",
      attributes: {
        name: poster.name,
        description: poster.description,
        price: poster.price.to_f, # Explicitly cast price to float
        year: poster.year,
        vintage: poster.vintage,
        img_url: poster.img_url
      }
    }
  end
end