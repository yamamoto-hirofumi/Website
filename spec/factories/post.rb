FactoryBot.define do
  factory :post do
    title { Faker::Lorem.characters(number: 10) }
    content { Faker::Lorem.characters(number: 100) }
    after(:create) do |post|
      create_list(:post_tag, 1, post: post, tag: create(:tag))
    end

    user
  end
end
