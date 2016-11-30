FactoryGirl.define do
  factory :basket do
    date { Faker::Date.backward}
    after(:build) do |basket|
      basket.user = FactoryGirl.build(:user)
    end
  end
end
