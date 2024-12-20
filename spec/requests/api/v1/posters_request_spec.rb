require 'rails_helper'
require 'pry'

RSpec.describe "Poster endpoints", type: :request do
  # ================== Index Endpoint =================
  describe "GET /index" do
    it "can send a list of posters" do
      # pending "add some examples to (or delete) #{__FILE__}"
      Poster.create!(name: "Success", description: "Progress over progression", price: 120.00, year: 2024, vintage: false, img_url: "https://gist.github.com/user-attachments/assets/7adbaca3-c952-49c9-b3ab-1c4dbb6e0fc8")
      Poster.create!(name: "Failure", description: "Wow, a different error message... Finally some progress!", price: 150.00, year: 1995, vintage: true, img_url: "https://gist.github.com/user-attachments/assets/d83e2aa5-b25a-4f9a-bed7-80b854da9bcc")

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
 
  #Koiree: This RSpec file tests the Posters API endpoints, specifically the "show" and "destroy" actions.
  # ================== Show Endpoint =================
  describe "GET /api/v1/posters/:id" do
    #Koiree: Create test data to ensure there is a poster record in the database for the test cases.
    let!(:poster) do
      Poster.create!(
        name: "FAILURE", 
        description: "Wow, a different error message... Finally some progress!", 
        price: 68.00, 
        year: 2019, 
        vintage: true, 
        img_url: "https://gist.github.com/user-attachments/assets/d83e2aa5-b25a-4f9a-bed7-80b854da9bcc"
      )
    end

    #Koiree: Store the ID of the created poster for easy access during tests.
    let(:poster_id) { poster.id }

    # ================== Successful Request =================
    #Koiree: Context for when the requested record exists.
    context "when the record exists" do
      it "returns the poster with the correct structure" do
        #Koiree: Send a GET request to fetch the poster by its ID.
        get "/api/v1/posters/#{poster_id}"

        #Koiree: Parse the JSON response to a Ruby hash with symbolized keys.
        json_response = JSON.parse(response.body, symbolize_names: true)

        # Debug: Inspect the full JSON response if something is wrong
        binding.pry if json_response.nil? || json_response[:data].nil?

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

        # Debug: Check the attributes hash if unexpected results
        binding.pry unless attributes.is_a?(Hash)

        #Koiree: Validate each field in the "attributes" section.
        expect(attributes[:name]).to eq("FAILURE")
        expect(attributes[:description]).to eq("Wow, a different error message... Finally some progress!")
        expect(attributes[:price]).to eq(68.00)
        expect(attributes[:year]).to eq(2019)
        expect(attributes[:vintage]).to be true
        expect(attributes[:img_url]).to eq("https://gist.github.com/user-attachments/assets/d83e2aa5-b25a-4f9a-bed7-80b854da9bcc")
      end
    end

    # ================== Sad Path Tests =================

    # ================== Sad Path: Record Not Found =================
    #Koiree: Context for when the requested record does not exist.
    context "when the record does not exist" do
      it "returns a not found message" do
        #Koiree: Send a GET request for a nonexistent poster ID (9999).
        get "/api/v1/posters/9999"

        #Koiree: Parse the JSON response to a Ruby hash with symbolized keys.
        json_response = JSON.parse(response.body, symbolize_names: true)

        # Debug: Check if the error message is correct
        binding.pry unless json_response[:error]

        #Koiree: Check that the HTTP response status is 404 Not Found.
        expect(response).to have_http_status(:not_found)

        #Koiree: Verify the error message in the response.
        expect(json_response[:error]).to eq("Poster not found")
      end
    end
  end
    # ================== Sad Path: Invalid ID Format =================
  # ================== Sad Path Missing Attributes Tests =================
  # POST Missing Attributes
  describe "POST /api/v1/posters with missing attributes" do
    it "returns 422 Unprocessable Entity with an error message" do
      poster_params = { name: "Incomplete Poster" }

      headers = { "CONTENT_TYPE" => "application/json" }
      post "/api/v1/posters", headers: headers, params: JSON.generate(poster: poster_params)

      json_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response[:errors]).to include("Description can't be blank")
      expect(json_response[:errors]).to include("Price can't be blank")
      expect(json_response[:errors]).to include("Year can't be blank")
      expect(json_response[:errors]).to include("Vintage is not included in the list")
      expect(json_response[:errors]).to include("Img url can't be blank")
    end
  end

  # ================== Sad Path Can't Create Duplicate Name Tests =================
  # POST Can't Create Duplicate Name
  describe "POST /api/v1/posters with duplicate name" do
    before do
      Poster.create!(
        name: "Duplicate Poster",
        description: "This is the first poster",
        price: 50.00,
        year: 2010,
        vintage: true,
        img_url: "https://example.com/duplicate-poster.jpg"
      )
    end

    it "returns 422 Unprocessable Entity with an error message" do
      poster_params = {
        name: "Duplicate Poster",
        description: "This is a duplicate",
        price: 45.00,
        year: 2020,
        vintage: false,
        img_url: "https://example.com/another-duplicate.jpg"
      }

      headers = { "CONTENT_TYPE" => "application/json" }
      post "/api/v1/posters", headers: headers, params: JSON.generate(poster: poster_params)

      json_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response[:errors]).to include("Name has already been taken")
    end
  end
 # ================== Sad Path Can't Update Duplicate Name =================
  # PATCH Can't Update Duplicate Name
  describe "PATCH /api/v1/posters/:id with duplicate name" do
    let!(:existing_poster) do
      Poster.create!(
        name: "Existing Poster",
        description: "Already exists",
        price: 60.00,
        year: 2015,
        vintage: true,
        img_url: "https://example.com/existing-poster.jpg"
      )
    end

    let!(:poster_to_update) do
      Poster.create!(
        name: "Poster to Update",
        description: "Will be updated",
        price: 40.00,
        year: 2018,
        vintage: false,
        img_url: "https://example.com/poster-to-update.jpg"
      )
    end

    it "returns 422 Unprocessable Entity with an error message" do
      updated_attributes = { name: "Existing Poster" }

      headers = { "CONTENT_TYPE" => "application/json" }
      patch "/api/v1/posters/#{poster_to_update.id}", headers: headers, params: JSON.generate(poster: updated_attributes)

      json_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response[:errors]).to include("Name has already been taken")
    end
  end
end

 # ================== DELETE Poster Test =================
  describe "DELETE /api/v1/posters/:id" do
    context "when the poster exists" do
      let!(:poster) do
        Poster.create!(
          name: "Delete Me",
          description: "Temporary poster",
          price: 50.00,
          year: 2010,
          vintage: true,
          img_url: "https://gist.github.com/user-attachments/assets/1f352aed-098f-4663-b35d-6a957dbd02b3"
        )
      end

      it "deletes the poster and returns 204" do
        expect {
          delete "/api/v1/posters/#{poster.id}"
        }.to change { Poster.count }.by(-1)

        expect(response).to have_http_status(:no_content)
      end
    end
 # ================== DELETE Does Not Exist Test =================
    context "when the poster does not exist" do
      it "returns a 404 not found status with an error message" do
        delete "/api/v1/posters/9999" # Non-existent ID

        expect(response).to have_http_status(:not_found)

        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:error]).to eq("Poster not found")
      end
    end
  end

  # ================== DELETE Test =================
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

# ================== Patch/Update Poster Test =================
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