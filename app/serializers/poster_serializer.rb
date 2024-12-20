class PosterSerializer
  def self.format_posters(posters, count)
    {
      data: posters.map do |poster|
        formatter(poster) # Calls the formatter method for each poster
      end,
      meta: count
    }
  end

 # Format the poster to match the desired JSON structure
  def self.format_poster(poster)
    {
      data: formatter(poster)
    }
  end
 
  def self.formatter(poster)
    {
      id: poster.id.to_s,
      type: "poster",
      attributes: {
        name: poster.name,
        description: poster.description,
        price: format("%.3f", poster.price).to_f,
        year: poster.year,
        vintage: poster.vintage,
        img_url: poster.img_url
      }
    }
  end
end