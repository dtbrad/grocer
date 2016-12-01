require 'rails_helper'

describe Product do

  it "has a valid factory" do
    expect(build(:product)).to be_valid
  end

  it "is invalid without a name" do
    product = build(:product, name: nil)
    product.valid?
    expect(product.errors[:name]).to include("can't be blank")
  end

  describe "knows about its purchase history" do
    before :each do
      @product = create(:product)
      @basket_one = create(:basket)
      @basket_two = create(:basket)
      @line_item_one = @product.line_items.create(basket_id: @basket_one.id, quantity: 1, price_cents: 900)
      @line_item_two = @product.line_items.create(basket_id: @basket_two.id, quantity: 5, price_cents: 300)
      @product.save
    end

    it "knows how many times it has been purchased" do
      expect(@product.times_bought).to eq 6
    end

    it "knows the highest price it sold for" do
      expect(@product.highest_price).to eq Money.new(900)
    end

    it "knows the lowest price it sold for" do
      expect(@product.lowest_price).to eq Money.new(300)
    end

  end

end
