require 'rails_helper'

describe Basket do
  it 'has a valid factory' do
    expect(build(:basket)).to be_valid
  end

  it 'is invalid without a date' do
    basket = build(:basket, date: nil)
    basket.valid?
    expect(basket.errors[:date]).to include("can't be blank")
  end

  it 'can display its total in dollars' do
    build(:basket, total_cents: nil)
    is_expected.to monetize(:total_cents)
  end

  it 'knows if one of its line_items has a discount' do
    basket = build(:basket)
    product = build(:product)
    build(:line_item, basket: basket, product: product, discount: 200)
    expect(basket.discount?).not_to eq(0)
  end

  it 'knows its quantity' do
    basket = create(:basket, :five_items_five_total)
    expect(basket.quantity).to eq(5)
  end

  context 'It knows about itself' do
    before :each do
      @basket1 =  create(:basket, :three_items_thirty_total, date: Time.parse('2017-01-14 08:59:54 -0800'))
      @basket2 =  create(:basket, :two_items_twenty_total, date: Time.parse('2017-01-18 08:59:54 -0800'))
      @basket3 =  create(:basket, :five_items_fifty_total, date: Time.parse('2017-01-19 08:59:54 -0800'))
      @basket4 =  create(:basket, :five_items_five_total, date: Time.parse('2017-02-14 08:59:54 -0800'))
      @basket5 =  create(:basket, :two_items_two_total, date: Time.parse('2017-03-14 08:59:54 -0800'))
      @basket6 =  create(:basket, :five_items_five_total, date: Time.parse('2017-04-14 08:59:54 -0800'))
      @basket7 =  create(:basket, :two_items_twenty_total, date: Time.parse('2017-05-14 08:59:54 -0800'))

      @graph_config1 = GraphConfig.new(start_date: '2017-01-14 08:59:54 -0800', end_date: '2017-04-14 08:59:54 -0800',
                                       unit: 'month')
      @graph_config2 = GraphConfig.new(start_date: '2017-01-14 08:59:54 -0800', end_date: '2017-02-14 08:59:54 -0800',
                                       unit: 'week')
      @graph_config3 = GraphConfig.new(start_date: '2017-01-14 08:59:54 -0800', end_date: '2017-01-20 08:59:54 -0800',
                                       unit: 'day')
      @baskets1 = Basket.from_graph(@graph_config1)
      @baskets2 = Basket.from_graph(@graph_config2)
      @baskets3 = Basket.from_graph(@graph_config3)
    end

    it 'returns an ActiveRecord association relation from the graph_config object' do
      expect(@baskets1.class).to eq(Basket::ActiveRecord_Relation)
    end

    it 'includes baskets from inside the time window set by the graph_config object' do
      expect(@baskets1.include?(@basket6)).to eq(true)
    end

    it 'does not include baskets from outside the time window set by the graph_config object' do
      expect(@baskets1.include?(@basket7)).to eq(false)
    end

    it 'groups properly' do
      baskets1 = @baskets1.group_baskets(@graph_config1)
      baskets2 = @baskets2.group_baskets(@graph_config2)
      baskets3 = @baskets2.group_baskets(@graph_config3)

      expect(baskets1).to eq(Date.parse('2017-01-01') => 1000, Date.parse('2017-02-01') => 500,
                             Date.parse('2017-03-01') => 200, Date.parse('2017-04-01') => 500)

      expect(baskets2).to eq(Date.parse('2017-01-08') => 3000, Date.parse('2017-01-15') => 7000,
                             Date.parse('2017-01-22') => 0, Date.parse('2017-01-29') => 0,
                             Date.parse('2017-02-05') => 0, Date.parse('2017-02-12') => 500)

      expect(baskets3).to eq(Date.parse('2017-01-14') => 3000, Date.parse('2017-01-15') => 0,
                             Date.parse('2017-01-16') => 0, Date.parse('2017-01-17') => 0,
                             Date.parse('2017-01-18') => 2000, Date.parse('2017-01-19') => 5000,
                             Date.parse('2017-01-20') => 0)
    end

    context 'Custom Sorting' do
      it 'can sort by date' do
        expect(@baskets1.custom_sort('sort_date', 'asc').first).to eq(@basket1)
        expect(@baskets1.custom_sort('sort_date', 'asc').last).to eq(@basket6)
        expect(@baskets1.custom_sort('sort_date', 'desc').first).to eq(@basket6)
        expect(@baskets1.custom_sort('sort_date', 'desc').last).to eq(@basket1)
      end

      it 'can sort by total' do
        expect(@baskets1.custom_sort('sort_total', 'asc').first).to eq(@basket5)
        expect(@baskets1.custom_sort('sort_total', 'asc').last).to eq(@basket3)
        expect(@baskets1.custom_sort('sort_total', 'desc').first).to eq(@basket3)
        expect(@baskets1.custom_sort('sort_total', 'desc').last).to eq(@basket5)
      end

      it 'can sort by number of items' do
        expect(@baskets1.custom_sort('sort_items', 'asc').first).to eq(@basket5)
        expect(@baskets1.custom_sort('sort_items', 'asc').last).to eq(@basket3)
        expect(@baskets1.custom_sort('sort_items', 'desc').first).to eq(@basket3)
        expect(@baskets1.custom_sort('sort_items', 'desc').last).to eq(@basket5)
      end
    end
  end
end
