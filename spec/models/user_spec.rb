require 'rails_helper'

describe User do
  it "has a valid factory" do
    expect(build(:user)).to be_valid
  end

  it "is invalid without a name" do
    user = build(:user, name: nil)
    user.valid?
    expect(user.errors[:name]).to include("can't be blank")
  end

  # describe "When deleting purchase history" do
  #   before do
  #     @user = create(:user)
  #     @user1 = create(:user)
  #     @basket = create(:basket, user: @user)
  #     @basket1 = create(:basket, user: @user)
  #     @basket2 = create(:basket, user: @user1)
  #
  #     @user.disassociate_baskets
  #   end
  #
  #   it "disassociates the user from their baskets" do
  #     expect(@basket.reload.user).to eq nil
  #     expect(@basket1.reload.user).to eq nil
  #   end
  #
  #   it "does not disassociate other users baskets" do
  #     expect(@basket2.reload.user).to eq @user1
  #   end
  # end
end
