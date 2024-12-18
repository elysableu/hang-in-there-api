require 'rails_helper'
require 'pry'

RSpec.describe "Poster endpoints", type: :request do
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