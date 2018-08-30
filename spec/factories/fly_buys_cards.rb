FactoryBot.define do
  factory :fly_buys_card do
    balance { Faker::Number.number(2) }
    number do
      "6014" + 1.upto(3).map { "-#{Faker::Number.number(4)}" }.join
    end
    trait :with_member do
      association :member
    end
  end
end
