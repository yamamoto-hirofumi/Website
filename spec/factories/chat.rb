FactoryBot.define do
  factory :chat do
    sequence(:message) { Faker::Lorem.characters(number: 30) }
    association :user
    association :room
  end
end
