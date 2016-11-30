FactoryGirl.define do
  factory :product do
    name { Faker::Name.name }
  end
end
