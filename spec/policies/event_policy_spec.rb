require 'rails_helper'

RSpec.describe EventPolicy do
  describe "destroy" do
    it "should not allow destroy if the user does not own the event" do
      user = FactoryBot.create(:user)
      event = FactoryBot.create(:event)
      expect(EventPolicy.new(user, event).destroy?).to eq(false)
    end
    it "should allow destroy if the user owns the event" do 
      user = FactoryBot.create(:user)
      event = FactoryBot.create(:event, user: user)
      expect(EventPolicy.new(user, event).destroy?).to eq(true)
    end
  end
end