FactoryBot.define do
  factory :login_history do
    association :user
    logind_at { 2021 / 9 / 20 }
  end
end
