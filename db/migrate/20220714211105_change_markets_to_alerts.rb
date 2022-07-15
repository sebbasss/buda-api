class ChangeMarketsToAlerts < ActiveRecord::Migration[7.0]
  def change
    rename_table :markets, :alerts
  end
end
