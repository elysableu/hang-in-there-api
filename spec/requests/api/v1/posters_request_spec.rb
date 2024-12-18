require 'rails_helper'

RSpec.describe "Posters endpoints", type: :request do
  describe "POST /create" do
    it "can post a new song" do 
      poster_params = {
                  name: "Authenticity",
                  description: "Truly being yourself in the face of adversity",
                  price: 69.99,
                  year: 1978,
                  vintage: true,
                  img_url: "https://davidirvine.com/living-and-leading-with-authenticity-how-weve-missed-the-mark-and-how-we-can-correct-it/"
                }
      
      headers = { "CONTENT_TYPE" => "application/json"}

      post "/api/v1/posters", headers: headers, params: JSON.generate(poster: poster_params)
      created_poster = Poster.last

      expect(response).to be_successful

      expect(created_poster.name).to eq(poster_params[:name])
      expect(created_poster.description).to eq(poster_params[:description])
      expect(created_poster.price).to eq(poster_params[:price])
      expect(created_poster.year).to eq(poster_params[:year])
      expect(created_poster.vintage).to eq(poster_params[:vintage])
      expect(created_poster.img_url).to eq(poster_params[:img_url])
    end
  end
end