FactoryGirl.define do
  factory :basket do
    transaction_date { Faker::Date.backward }
    total_cents { Faker::Number.number(4) }

    trait :five_items_fifty_total do
      after(:create) do |basket|
        5.times { create(:line_item, :ten_total, basket: basket) }
        basket.update(total: 50)
      end
    end

    trait :three_items_thirty_total do
      after(:create) do |basket|
        3.times { create(:line_item, :ten_total, basket: basket) }
        basket.update(total: 30)
      end
    end

    trait :two_items_twenty_total do
      after(:create) do |basket|
        2.times { create(:line_item, :ten_total, basket: basket) }
        basket.update(total: 20)
      end
    end

    trait :five_items_five_total do
      after(:create) do |basket|
        5.times { create(:line_item, :one_total, basket: basket) }
        basket.update(total: 5)
      end
    end

    trait :two_items_two_total do
      after(:create) do |basket|
        2.times { create(:line_item, :one_total, basket: basket) }
        basket.update(total: 2)
      end
    end
  end
end
