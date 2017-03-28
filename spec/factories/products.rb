FactoryGirl.define do
  factory :product do
    name { Faker::Name.name }
    sequence :nickname do |n|
      "#{Faker::Name.name}#{n}"
    end
  end
end
