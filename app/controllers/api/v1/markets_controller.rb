require 'json'
require 'open-uri'

class Api::V1::MarketsController < ApplicationController

  # Used to display all markets, extracting them from the api or updating their spread.
  def index
    spreads = extract_spreads
    markets = []
    if Market.exists?
      saved_markets = Market.order(created_at: :asc)
      saved_markets.each_with_index do |market, index|
        market.spread = spreads[index][:spread]
        market.save
        markets.push(market_info(market))
      end
    else
      spreads.each do |spread|
        market = Market.new(name: spread[:name], spread: spread[:spread])
        market.save
        markets.push(market_info(market))
      end
    end
    data = { markets: markets }
    render json: data
  end

  # Used to show only one market, if it exists, update its information, extract all markets info.
  def show
    if !extract_spreads[0].has_value?(params[:id].upcase)
      render json: "Market not found"
    else
      response = call_api("https://www.buda.com/api/v2/markets/#{params[:id]}/ticker")
      market_data = {}
      if Market.exists?
        market = Market.find_by name: params[:id].upcase
        market.spread = calc_spread(response['ticker'])
        market.save
        market_data = market_info(market)
      else
        fill_db
        market = Market.find_by name: params[:id].upcase
        market.spread = calc_spread(response['ticker'])
        market.save
        market_data = market_info(market)
      end
      data = { market: market_data }
      render json: data
    end
  end

  # Used to add an alert spread.
  def add_alert
    if Market.find_by name: params[:market_id].upcase
      market = Market.find_by name: params[:market_id].upcase
      alert_spread = params[:alert_spread].gsub!(',', '.')
      market.alert_spread = alert_spread
      market.save
      market_data  = market_info(market)
      redirect_to api_v1_markets_path
    else
      render json: "Market not found"
    end
  end

  private

  # Structuring the data to be displayed in json.
  def market_info(market)
    { name: market.name, spread: market.spread, alert_spread: market.alert_spread }
  end

  # Used to calculate to fill the database when database does not contin any markets.
  def fill_db
    spreads = extract_spreads
    spreads.each do |spread|
      market = Market.new(name: spread[:name], spread: spread[:spread])
      market.save
    end
  end

  # Used to call the api and parse the json response.
  def call_api(url)
    response_serialized = URI.open(url).read
    JSON.parse(response_serialized)
  end

  # Used to calculate the spread.
  def calc_spread(market)
    ((market['min_ask'][0].to_f - market['max_bid'][0].to_f) / market['min_ask'][0].to_f).round(6).to_s
  end

  # Used to get the names of all markets, later used to get the spreads.
  def extract_names
    response = call_api('https://www.buda.com/api/v2/markets')
    markets = response['markets']
    names = []
    markets.each do |market|
      names.push(market['id'])
    end
    names
  end

  # Used to calculate the spreads for each market, then saving them in an array.
  def extract_spreads
    names = extract_names
    spreads = []
    names.each do |name|
      response = call_api("https://www.buda.com/api/v2/markets/#{name}/ticker")
      market = response['ticker']
      spreads.push({ name: name, spread: calc_spread(market) })
    end
    spreads
  end
end
