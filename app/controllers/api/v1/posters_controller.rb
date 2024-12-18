module Api
  module V1
    class PostersController < ApplicationController
      # GET /api/v1/posters/:id
      def show
        poster = Poster.find_by(id: params[:id])
        if poster
          render json: format_poster(poster), status: :ok
        else
          render json: { error: "Poster not found" }, status: :not_found
        end
      end

      private

      # Format the poster to match the desired JSON structure
      def format_poster(poster)
        {
          data: {
            id: poster.id.to_s,
            type: "poster",
            attributes: {
              name: poster.name,
              description: poster.description,
              price: poster.price,
              year: poster.year,
              vintage: poster.vintage,
              img_url: poster.img_url
            }
          }
        }
      end
    end
  end
end
