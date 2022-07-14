require 'json'
require 'open-uri'

class Api::V1::MarketsController < ApplicationController

  def index
    spreads = get_spreads
    markets = []
    spreads.each do |spread|
      market = Hash.new
      market[:name] = spread[:name]
      market[:spread] = spread[:spread].to_f
      markets.push(market)
    end
    render json: markets
  end

  def show
    name = params[:id]
    res = call_api("https://www.buda.com/api/v2/markets/#{name}/ticker")
    market = Hash.new
    market[:name] = res["ticker"]["market_id"]
    market[:spread] = ((res["ticker"]["min_ask"][0].to_f - res["ticker"]["max_bid"][0].to_f) / res["ticker"]["min_ask"][0].to_f)
    render json: market
  end

  private

  def call_api(url)
    res_serialized = URI.open(url).read
    JSON.parse(res_serialized)
  end

  def get_names
    res = call_api('https://www.buda.com/api/v2/markets')
    all_markets = res["markets"]
    names = []
    all_markets.each do |market|
      names.push(market["id"])
    end
    names
  end

  def get_spreads
    names = get_names
    spreads = []
    names.each do |name|
      res = call_api("https://www.buda.com/api/v2/markets/#{name}/ticker")
      market = res["ticker"]
      spreads.push({ name: name,
                     spread: ((market['min_ask'][0].to_f - market['max_bid'][0].to_f) / market['min_ask'][0].to_f) })
    end
    spreads
  end
end
