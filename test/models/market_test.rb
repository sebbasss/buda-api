require "test_helper"

class MarketTest < ActiveSupport::TestCase
  test "should not save without name" do
    market = Market.new
    market.spread = "0.3"
    assert_not market.save
  end

  test "should not save without spread" do
    market = Market.new
    market.name = "btc-clp"
    assert_not market.save
  end

  test "should be saved with name and spread" do
    market = Market.new
    market.spread = "0.3"
    market.name = "btc-clp"
    assert market.save
  end
end
