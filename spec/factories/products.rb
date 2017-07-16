FactoryGirl.define do
  factory :product do
    name { Faker::Name.name }
    nickname { Faker::Name.name }

    trait :with_real_unit_price do
      real_unit_price 4
    end
  end
end
