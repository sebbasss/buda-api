require 'json'
require 'open-uri'

class Api::V1::MarketsController < ApplicationController

  def index
    spreads = extract_spreads
    markets = []
    spreads.each do |spread|
      market = {}
      market[:name] = spread[:name]
      market[:spread] = spread[:spread].to_f
      markets.push(market)
    end
    data = { "markets": markets }
    render json: data
  end

  def show
    name = params[:id]
    response = call_api("https://www.buda.com/api/v2/markets/#{name}/ticker")
    market = {}
    market[:name] = response['ticker']['market_id']
    market[:spread] = calc_spread(response['ticker'])
    data = { 'market': market }
    render json: data
  end

  private

  def call_api(url)
    response_serialized = URI.open(url).read
    JSON.parse(response_serialized)
  end

  def calc_spread(market)
    ((market['min_ask'][0].to_f - market['max_bid'][0].to_f) / market['min_ask'][0].to_f).round(5)
  end

  def extract_names
    response = call_api('https://www.buda.com/api/v2/markets')
    markets = response['markets']
    names = []
    markets.each do |market|
      names.push(market['id'])
    end
    names
  end

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
