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
 
  #Koiree: This RSpec file tests the Posters API endpoints, specifically the "show" action.
  #Koiree: Testing the GET /api/v1/posters/:id endpoint
  describe "GET /api/v1/posters/:id" do
       #Koiree: Create test data to ensure there is a poster record in the database for the test cases.
    let!(:poster) do
      Poster.create!(
        name: "FAILURE", #Test poster's name.
        description: "Why bother trying? It's probably not worth it.", #Test poster's description.
        price: 68.00, #Test poster's price.
        year: 2019, #Test poster's year of creation.
        vintage: true, #Indicates if the poster is vintage.
        img_url: "https://images.unsplash.com/photo-1620401537439-98e94c004b0d" #Test poster's image URL.
      )
    end

    #Koiree: Store the ID of the created poster for easy access during tests.
    let(:poster_id) { poster.id }
    #Koiree: Context for when the requested record exists.
    context "when the record exists" do
      it "returns the poster with the correct structure" do
        #Koiree: Send a GET request to fetch the poster by its ID.
        get "/api/v1/posters/#{poster_id}"

        #Koiree: Parse the JSON response to a Ruby hash with symbolized keys.
        json_response = JSON.parse(response.body, symbolize_names: true)

        #Koiree: Check that the HTTP response status is 200 OK.
        expect(response).to have_http_status(:ok)

        #Koiree: Verify that the response contains a top-level "data" key.
        expect(json_response).to have_key(:data)

        #Koiree: Extract the "data" hash for further validations.
        data = json_response[:data]

        #Koiree: Check that the ID is correct and returned as a string.
        expect(data[:id]).to eq(poster_id)

        #Koiree: Verify that the type key matches the expected resource type.
        expect(data[:type]).to eq("poster")

        #Koiree: Extract the "attributes" section for validation.
        attributes = data[:attributes]

        #Koiree: Validate each field in the "attributes" section.
        expect(attributes[:name]).to eq("FAILURE") #Koiree: Verify the "name" matches.
        expect(attributes[:description]).to eq("Why bother trying? It's probably not worth it.") #Koiree: Verify the "description".
        expect(attributes[:price]).to eq(68.00) #Koiree: Verify the "price" matches.
        expect(attributes[:year]).to eq(2019) #Koiree: Verify the "year" matches.
        expect(attributes[:vintage]).to be true #Koiree: Verify the "vintage" field is true
        expect(attributes[:img_url]).to eq("https://images.unsplash.com/photo-1620401537439-98e94c004b0d") #Koiree: Verify the "img_url".
      end
    end

    #Koiree: Context for when the requested record does not exist.
    context "when the record does not exist" do
      it "returns a not found message" do
        #Koiree: Send a GET request for a nonexistent poster ID (9999).
        get "/api/v1/posters/9999"

        #Koiree: Parse the JSON response to a Ruby hash with symbolized keys.
        json_response = JSON.parse(response.body, symbolize_names: true)

        #Koiree: Check that the HTTP response status is 404 Not Found.
        expect(response).to have_http_status(:not_found)

        #Koiree: Verify the error message in the response.
        expect(json_response[:error]).to eq("Poster not found") #Koiree: Verify the "error" message.
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

  describe "GET /api/v1/posters?sort=asc" do
    it "can sort posters by created_at in ascending order" do
      posterSuccess = Poster.create!(name: "Success", description: "Progress over progression", price: 120.00, year: 2024, vintage: false, img_url: "https://gist.github.com/user-attachments/assets/7adbaca3-c952-49c9-b3ab-1c4dbb6e0fc8")
      posterFailure = Poster.create!(name: "Failure", description: "Loss over win", price: 150.00, year: 1995, vintage: true, img_url: "https://despair.com/cdn/shop/products/failure-is-not-an-option.jpg?v=1569992574")

      get "/api/v1/posters?sort=asc"

      expect(response).to be_successful
      posters = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(posters.count).to eq(2)

      expect(posters[0][:id].to_i).to eq(posterSuccess.id)
      expect(posters[1][:id].to_i).to eq(posterFailure.id)
    end
  end

  describe "GET /api/v1/posters?sort=desc" do
    it "can sort posters by created_at in descending order" do
      posterSuccess = Poster.create!(name: "Success", description: "Progress over progression", price: 120.00, year: 2024, vintage: false, img_url: "https://gist.github.com/user-attachments/assets/7adbaca3-c952-49c9-b3ab-1c4dbb6e0fc8")
      posterFailure = Poster.create!(name: "Failure", description: "Loss over win", price: 150.00, year: 1995, vintage: true, img_url: "https://despair.com/cdn/shop/products/failure-is-not-an-option.jpg?v=1569992574")

      get "/api/v1/posters?sort=desc"

      expect(response).to be_successful
      posters = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(posters.count).to eq(2)
      
      expect(posters[0][:id].to_i).to eq(posterFailure.id)
      expect(posters[1][:id].to_i).to eq(posterSuccess.id)
    end
  end
  
  describe " GET /count" do
    before(:each) do
      Poster.create(
        name: "Authenticity",
        description: "Truly being yourself in the face of adversity",
        price: 69.99,
        year: 1978,
        vintage: true,
        img_url: "https://davidirvine.com/living-and-leading-with-authenticity-how-weve-missed-the-mark-and-how-we-can-correct-it/"
      )
      
      Poster.create(
        name: "???????",
        description: "Yay more confusion",
        price: 19.99,
        year: 2000,
        vintage: false,
        img_url: "https://media.npr.org/assets/img/2015/12/14/confused-2eb86f2e782cd35f3932f9bd34e48788d0741e9d.jpg"
      )
    end

    it "can count existing posters" do
      get "/api/v1/posters"
      posters = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(posters[:meta][:count]).to eq(2)
    end
  end
end