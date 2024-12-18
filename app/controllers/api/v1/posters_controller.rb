class Api::V1::PostersController < ApplicationController
  
  def index 
    posters = Poster.all
    render json: PosterSerializer.format_posters(posters)
  end
  
  def create
    render json: Poster.create(poster_params)
  end

  private

  def poster_params
    params.require(:poster).permit(:name, :description, :price, :year, :vintage, :img_url)
  end
  
end