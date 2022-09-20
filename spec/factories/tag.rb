FactoryBot.define do
  factory :tag do
    sequence(:name) { Faker::Lorem.characters(number: 2) }
  end
end
