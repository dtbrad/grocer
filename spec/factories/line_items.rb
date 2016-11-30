FactoryGirl.define do
  factory :line_item do
    price_cents { Faker::Number.between(1,10) }
    quantity { Faker::Number.between(1,10) }

    after(:build) do |line_item|
      line_item.product = build(:product)
      line_item.basket = build(:basket)
    end
  end
end
