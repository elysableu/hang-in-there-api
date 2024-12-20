class Api::V1::PostersController < ApplicationController
  
  def index 
    # sort order if there is a parameter
    sort = { "desc" => :desc, "asc" => :asc }[params[:sort]]   
    # fetch the poster if there is a parameter and if not it will default to fetching all with no parameters
    posters = sort ? Poster.order(created_at: sort) : Poster.all
<<<<<<< HEAD

    if params[:name].present? 
      posters = Poster.where("name ILIKE ?", "%#{params[:name]}%")
    elsif params[:min_price].present? 
      posters = Poster.where("price >= ?", params[:min_price])
    elsif params[:max_price].present?
      posters = Poster.where("price <= ?", params[:max_price])
    end

    render json: PosterSerializer.format_posters(posters, {count: posters.count})
=======
    render json: PosterSerializer.format_posters(posters, {count: Poster.all.count}))
>>>>>>> 8f5cd29761602b237c3456db13566d60ba33a941
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

  private
  
  def poster_params
    params.require(:poster).permit(:name, :description, :price, :year, :vintage, :img_url)
  end
end


