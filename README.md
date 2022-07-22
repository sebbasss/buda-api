This simple rails API is designed to access BUDA's api, calculate the spread of each market, display the spread of a single or all markets, and add an alert_spread to a market.
This was done my creating a model 'Market' with the following attributes: name:string, spread:string, and alert_spread:string.
For an instance of Market to be created, ActiveRecords validates the presence of name and spread, but not alert_spread, since the value is given later.
The endpoints of the API are the following:
- api/v1/markets -> MarketsController#index (displays all markets)
- api/v1/markets/:id -> MarketsController#show (displays a single market, market.name = params[:id])
- api/v1/markets/:market_id/:alert_spread -> MarketsController#add_alert (gives an alert_spread to the given market, params[:alert_spread = market.alert_spread).

IMPORTART: the alert spread has to be given with a comma separator, not a dot => 0,003  NOT 0.003.

One of the main security issues of this API is that everyone can access it (cors configuration allowing it), and that the add_alert method is triggered by a GET request. This is due to the fact that this API is not to be deployed and also because I don't have much experience creating APIs :), but highly motivated to learn.
Some tests where implemented in order to make sure that the model validations are working, and that the controller is indeed warning the user that the markets they are looking for do not exist.

This API uses the following gems and versions:
- ruby "3.0.3"
- "rails", "~> 7.0.3", ">= 7.0.3.1"
- pg, "~> 1.1"
- rack-cors
- rspec-rails
Make sure you have them installed and updated before using it!

Finally, a more detailed explanation of the code can be found in the following link (notion): 
https://paint-bridge-22d.notion.site/CODE-EXPLANATION-75889a77c88d4c01be4cbc8925afa45a
