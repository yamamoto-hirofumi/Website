FactoryBot.define do
  factory :notification do
    association :post
    association :user
    association :post_comment
    association :favorite
  end
end
