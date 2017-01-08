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
      @user = create(:user)
      @user_two = create(:user)

      @product_one = create(:product)
      @product_two = create(:product)

      @basket_one = @user.baskets.create(date: '2016-01-01')
      @line_item_one = @product_one.line_items.create(basket_id: @basket_one.id, quantity: 1, price_cents: 900, total_cents: 900)
      @line_item_two = @product_two.line_items.create(basket_id: @basket_one.id, quantity: 20, price_cents: 500, total_cents: 10000)

      @basket_two = @user.baskets.create(date: '2016-01-01')
      @line_item_two = @product_one.line_items.create(basket_id: @basket_two.id, quantity: 5, price_cents: 300, total_cents: 1500)

      @basket_three = @user_two.baskets.create(date: '2016-01-01')
      @line_item_three = @product_one.line_items.create(basket_id: @basket_three.id, quantity: 1, price_cents: 600, total_cents: 600)
      @line_item_four = @product_two.line_items.create(basket_id: @basket_three.id, quantity: 3, price_cents: 400, total_cents: 1200)

      @product_one.save
      @product_two.save
    end

    it "knows how many times it has been purchased by a user" do
      expect(@product_one.times_bought(@user)).to eq 6
      expect(@product_two.times_bought(@user)).to eq 20
    end

    it "knows the highest price it sold for" do
      expect(@product_one.highest_price).to eq Money.new(900)
    end

    it "knows the lowest price it sold for" do
      expect(@product_one.lowest_price).to eq Money.new(300)
    end

    it "knows the most popular product" do
      expect(Product.most_popular_product).to eq @product_two
    end

    it "knows the most expensive product" do
      expect(Product.most_expensive_product).to eq @product_one
    end

    it "knows the most expensive product by user" do
      expect(Product.most_expensive_product_by_user(@user)).to eq @product_one
      expect(Product.most_expensive_product_by_user(@user_two)).to eq @product_one

    end

    it "knows the least expensive product" do
      expect(Product.least_expensive_product).to eq @product_one
    end

    it "knows the least expensive product by user" do
      expect(Product.least_expensive_product_by_user(@user)).to eq @product_one
      expect(Product.least_expensive_product_by_user(@user_two)).to eq @product_two

    end
  end
end
