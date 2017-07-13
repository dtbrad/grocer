FactoryGirl.define do
  factory :line_item do
    price_cents { Faker::Number.between(1, 10) }
    quantity { Faker::Number.between(1, 10) }
    total_cents { price_cents * quantity }
    association :product
    association :basket
  end
end
