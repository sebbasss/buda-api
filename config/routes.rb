Rails.application.routes.draw do
  namespace "api" do
    namespace "v1" do
      resources :markets, only: %i[index show]
      get "markets/:id/:alert_spread", to: "markets#add_alert"
    end
  end
end
