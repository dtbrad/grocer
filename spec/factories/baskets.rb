FactoryGirl.define do
  factory :basket do
    date { Faker::Date.backward }
    total_cents { Faker::Number.number(4) }
  end
end
