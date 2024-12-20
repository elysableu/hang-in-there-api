class Api::V1::PostersController < ApplicationController
  
  def index 
    # sort order if there is a parameter
    sort = { "desc" => :desc, "asc" => :asc }[params[:sort]]   
    # fetch the poster if there is a parameter and if not it will default to fetching all with no parameters
    posters = sort ? Poster.order(created_at: sort) : Poster.all
    render json: PosterSerializer.format_posters(posters, {count: Poster.all.count})
  end
  
 # GET /api/v1/posters/:id
  def show
    poster = Poster.find_by(id: params[:id])
    if poster
      render json: PosterSerializer.format_poster(poster), status: :ok
    else
      render json: { error: "Poster not found" }, status: :not_found
    end
  end
  
  def create
    render json: Poster.create(poster_params)
  end

  def update
    render json: Poster.update(params[:id], poster_params)
  end

  # DELETE /api/v1/posters/:id
  def destroy
    # Directly check for the poster until the error manager is implemented
    poster = Poster.find_by(id: params[:id])

    if poster
      poster.destroy
      head :no_content
    else
      render json: { error: "Poster not found" }, status: :not_found
    end
  end

  # Koiree: Whenever the Error Manager is implemented 
  # def destroy
  #   # Koiree: Let Error Manager handle if the poster is not found
  #   poster = Poster.find(params[:id])

  #   # Koiree: Destroy the record and return 204 No Content
  #   poster.destroy
  #   head :no_content
  # end

  private
  
  def poster_params
    params.require(:poster).permit(:name, :description, :price, :year, :vintage, :img_url)
  end
end

