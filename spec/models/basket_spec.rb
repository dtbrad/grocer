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
end
