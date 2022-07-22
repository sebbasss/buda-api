require "test_helper"

class MarketsControllerTest < ActionDispatch::IntegrationTest
  test "should render json message when market does not exists" do
    market = Market.new
    market.name = "xxxxx"
    get "/api/v1/markets/#{market.name}/"
    assert_equal "Market not found", @response.body
  end

  test "redirects when alert spread is saved" do
    market = Market.new(name: "BTC-USD", spread: "0.002")
    market.alert_spread = "0.003"
    market.save
    get "/api/v1/markets/#{market.name}/#{market.alert_spread}"
    assert_response :redirect
  end

  test "when saving alert spread, should render json message if market does not exists" do
    market = Market.new(name: "xxxx", spread: "0.002")
    market.alert_spread = "0.003"
    get "/api/v1/markets/#{market.name}/#{market.alert_spread}"
    assert_equal "Market not found", @response.body
  end
end
