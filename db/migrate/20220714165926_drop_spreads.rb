class DropSpreads < ActiveRecord::Migration[7.0]
  def change
    drop_table :spreads
  end
end
