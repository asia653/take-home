require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "v1" do
    describe "POST /login" do
      it 'logs a user in' do
        headers = { "ACCEPT" => "application/json" }
        user = FactoryBot.create(:user, password: "longpassword")
        post "/v1/login", :params => { email: user.email, password: "longpassword" }, headers: headers
        expect(@response).to have_http_status(200)
        expect(@response.parsed_body["message"]).to eq('successfully logged in')
        expect(@response.parsed_body["token"].blank?).to_not be(true)
      end

      it 'returns an error message if the credentials are incorrect' do
        headers = { "ACCEPT" => "application/json" }
        # user = FactoryBot.create(:user, password: "longpassword")
        post "/v1/login", :params => { email: 'random@test.com', password: "longpassword" }, headers: headers
        expect(@response).to have_http_status(400)
        expect(@response.parsed_body["message"]).to eq('incorrect credentials')
      end
    end
    describe "POST /signup" do
      it 'creates a user' do
        headers = { "ACCEPT" => "application/json" }
        expect {
          post "/v1/signup", :params => { user: {name: "Edward", password: "randomlongpassword", email: "edward@test.com" } }, headers: headers
        }.to change(User, :count).by(1)
        expect(@response).to have_http_status(200)
        expect(@response.parsed_body["message"]).to eq("user has been registered")
        expect(@response.parsed_body["token"].blank?).to_not be(true)

      end

      it "renders the correct error response" do
        headers = { "ACCEPT" => "application/json" }
        expect {
          response = post "/v1/signup", :params => { user: {name: "", password: "", email: "" } }, headers: headers
        }.to_not change(User, :count)
        expect(@response).to have_http_status(400)
        expect(@response.parsed_body["message"]).to eq("there was an issue registering the user")
        expect(@response.parsed_body.keys).to include("errors")
      end
    end
  end
end
