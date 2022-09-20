FactoryBot.define do
  factory :post_comment do
    association :post
    user { post.user }
    comment { Faker::Lorem.characters(number: 10) }
  end
end
