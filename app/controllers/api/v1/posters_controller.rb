class Api::V1::PostersController < ApplicationController
    def create
      render json: Poster.create(poster_params)
    end
end