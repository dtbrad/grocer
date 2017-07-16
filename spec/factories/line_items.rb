FactoryGirl.define do
  factory :line_item do
    price_cents { Faker::Number.between(1, 10) }
    quantity { Faker::Number.between(1, 10) }
    total_cents { price_cents * quantity }
    association :product
    association :basket

    trait :ten_total do
      price 1
      quantity 10
    end

    trait :five_total do
      price 1
      quantity 5
    end

    trait :one_total do
      price 1
      quantity 1
    end
  end
end
