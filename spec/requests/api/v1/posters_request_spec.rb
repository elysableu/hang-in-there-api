require 'rails_helper'
require 'pry'

RSpec.describe "Poster endpoints", type: :request do
  describe "GET /index" do
    it "can send a list of posters" do
      # pending "add some examples to (or delete) #{__FILE__}"
      Poster.create!(name: "Success", description: "Progress over progression", price: 120.00, year: 2024, vintage: false, img_url: "https://gist.github.com/user-attachments/assets/7adbaca3-c952-49c9-b3ab-1c4dbb6e0fc8")
      Poster.create!(name: "Failure", description: "Loss over win", price: 150.00, year: 1995, vintage: true, img_url: "https://despair.com/cdn/shop/products/failure-is-not-an-option.jpg?v=1569992574")

      get "/api/v1/posters"

      expect(response).to be_successful

      posters = JSON.parse(response.body, symbolize_names: true)

      expect(posters[:data].count).to eq(2)

      posters[:data].each do |poster|
        expect(poster).to have_key(:attributes)
        expect(poster[:attributes]).to have_key(:name)
        expect(poster[:attributes][:name]).to be_a(String)

        expect(poster[:attributes]).to have_key(:description)
        expect(poster[:attributes][:description]).to be_a(String)

        expect(poster[:attributes]).to have_key(:price)
        expect(poster[:attributes][:price]).to be_a(Float)

        expect(poster[:attributes]).to have_key(:year)
        expect(poster[:attributes][:year]).to be_a(Integer)

        # binding.pry 
        expect(poster[:attributes]).to have_key(:vintage)
        expect(poster[:attributes][:vintage]).to be_in([true, false])


        expect(poster[:attributes]).to have_key(:img_url)
        expect(poster[:attributes][:img_url]).to be_a(String)
      end
    end
  end
  
  describe "POST /create" do
    it "can post a new poster" do 
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

  describe "PATCH /update" do
    it "can update an existing poster" do
      poster = Poster.create!(
        name: "???????",
        description: "Yay more confusion",
        price: 19.99,
        year: 2000,
        vintage: false,
        img_url: "https://media.npr.org/assets/img/2015/12/14/confused-2eb86f2e782cd35f3932f9bd34e48788d0741e9d.jpg"
      )

      updated_attributes = {
        name: "!!!!!!!",
        description: "No more confusion!",
        price: 20.99,
        year: 2010,
        vintage: true,
        img_url: "https://www.shutterstock.com/image-vector/operation-thinking-understand-mastering-new-260nw-2461099445.jpg"
      }

      headers = { "CONTENT_TYPE" => "application/json"}

      patch "/api/v1/posters/#{poster.id}", headers: headers, params: JSON.generate(poster:  updated_attributes)
      poster_updated = Poster.find(poster.id)
      
      expect(response).to be_successful

      expect(poster_updated.name).to eq(updated_attributes[:name])
      expect(poster_updated.description).to eq(updated_attributes[:description])
      expect(poster_updated.price).to eq(updated_attributes[:price])
      expect(poster_updated.year).to eq(updated_attributes[:year])
      expect(poster_updated.vintage).to eq(updated_attributes[:vintage])
      expect(poster_updated.img_url).to eq(updated_attributes[:img_url])
    end
  end
end