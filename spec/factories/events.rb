FactoryBot.define do
  factory :event do
    sequence(:name) { |n| "test-event-#{n}" }
    sequence(:location) { |n| "test-location-#{n}" }
    start_time { Time.zone.now }
    end_time { start_time + 5.hours}
    user
  end
end
