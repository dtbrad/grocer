require 'rails_helper'

describe Basket do
  it "has a valid factory" do
    expect(build(:basket)).to be_valid
  end

  it "is invalid without a date" do
    basket = build(:basket, date: nil)
    basket.valid?
    expect(basket.errors[:date]).to include("can't be blank")
  end

  it "can display its total in dollars" do
    build(:basket, total_cents: nil)
    is_expected.to monetize(:total_cents)
  end

  it "knows if one of its line_items has a discount" do
    basket = build(:basket)
    product = build(:product)
    build(:line_item, basket: basket, product: product, discount: 200)
    expect(basket.discount?).not_to eq(0)
  end
end
