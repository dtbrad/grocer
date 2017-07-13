FactoryGirl.define do
  factory :basket do
    date { Faker::Date.backward }
  end
end
