class FixColumnNames < ActiveRecord::Migration[7.0]
  def change
    rename_column :alerts, :name, :market_name
    remove_column :alerts, :alert
  end
end
