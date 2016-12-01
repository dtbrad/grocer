require 'rails_helper'

describe LineItem do

  it "has a valid factory" do
    expect(build(:line_item)).to be_valid
  end

  it "is invalid without a price" do
    line_item = build(:line_item, price_cents: nil)
    line_item.valid?
    expect(line_item.errors[:price_cents]).to include("can't be blank")
  end

  it "is invalid without a quantity" do
    line_item = build(:line_item, quantity: nil)
    line_item.valid?
    expect(line_item.errors[:quantity]).to include("can't be blank")
  end

  it "is invalid without a product" do
    line_item = build(:line_item)
    line_item.product = nil
    line_item.valid?
    expect(line_item.errors[:product]).to include("must exist")
  end

  it "is invalid without a basket" do
    line_item = build(:line_item)
    line_item.basket = nil
    line_item.valid?
    expect(line_item.errors[:basket]).to include("must exist")
  end

  it "matches model attribute without a '_cents' suffix by default" do
     is_expected.to monetize(:price)
   end


end
