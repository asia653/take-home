FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "tester-#{n}@example.com" }
    sequence(:name) { |n| "test-#{n}" }
    password { SecureRandom.hex }

  end 
end
