require 'rails_helper'

#Koiree: This RSpec file tests the Posters API endpoints, specifically the "show" action.
RSpec.describe "Posters API", type: :request do
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

  #Koiree: Testing the GET /api/v1/posters/:id endpoint
  describe "GET /api/v1/posters/:id" do
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
        expect(data[:id]).to eq(poster_id.to_s)

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
end
