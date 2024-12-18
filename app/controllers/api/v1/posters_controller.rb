class Api::V1::PostersController < ApplicationController
    def create
      render json: Poster.create(poster_params)
    end
    
    private

    def poster_params
      params.require(:poster).permit(:name, :description, :price, :year, :vintage, :img_url)
    end
end