require 'rails_helper'

RSpec.describe "Events", type: :request do
  describe "v1" do
    before(:each) do
      @user_password = "longpassword"
      @user = FactoryBot.create(:user, password: @user_password)
    end
    describe "PUT /events/:id" do
      it "should update events" do
        event = FactoryBot.create(:event, name: "sample event 6000", user: @user)
        token = sign_in_as(@user.email, @user_password)
        expect {
          put "/v1/events/#{event.id}", params: { name: "sample event 7000" }, headers: { "Authorization": "Bearer #{token}" }, as: :json
        }.to change { event.reload.name }.from("sample event 6000").to("sample event 7000")
        expect(@response).to have_http_status(200)
        expect(@response.parsed_body["message"]).to eq("event has been updated")
      end
    end
    describe "DESTROY /events/:id" do
      it "should destroy events" do
        event = FactoryBot.create(:event, user: @user)
        token = sign_in_as(@user.email, @user_password)
        expect {
          delete "/v1/events/#{event.id}", headers: { "Authorization": "Bearer #{token}" }, as: :json
        }.to change(Event, :count).by(-1)
        expect(@response).to have_http_status(200)
        expect(@response.parsed_body["message"]).to eq("event has been deleted")
      end
    end
    describe "GET /events/:id" do
      it "should return an event" do
        event = FactoryBot.create(:event)
        get "/v1/events/#{event.id}", as: :json
        expect(@response).to have_http_status(200)
        expect(@response.parsed_body["event"]["id"]).to eq(event.id)
      end
    end
    describe "GET /events" do
      it "should return a list of all events" do
        event = FactoryBot.create(:event)
        get "/v1/events", as: :json
        expect(@response.parsed_body["events"].count).to eq(1)
        expect(@response).to have_http_status(200)
        expect(@response.parsed_body["events"][0]["id"]).to eq(event.id)
      end
    end

    describe "POST /events" do
      it "should create an event" do
        token = sign_in_as(@user.email, @user_password)
        @new_event = FactoryBot.build(:event, name: "random event name 1990")
        post "/v1/events", params: { 
          event: { 
            name: @new_event.name, 
            location: @new_event.location, 
            start_time: @new_event.start_time, 
            end_time: @new_event.end_time
          }
        }, 
        as: :json,
        headers: {
          "Authorization": "Bearer #{token}"
        }
        expect(@response).to have_http_status(200)
        expect(@response.parsed_body["event"]["name"]).to eq("random event name 1990")
        expect(@response.parsed_body["message"]).to eq("event has been created")
      end
      it "should fail at creating an event" do
        token = sign_in_as(@user.email, @user_password)
        @new_event = FactoryBot.build(:event, name: "random event name 1990")
        post "/v1/events",
        as: :json,
        params: {
          event: {
            name: "random event name"
          }
        },
        headers: {
          "Authorization": "Bearer #{token}"
        }
        expect(@response).to have_http_status(400)
        expect(@response.parsed_body.keys.include?("errors")).to eq(true)
        expect(@response.parsed_body["message"]).to eq("there was an issue creating the event")
      end
    end
  end
end
