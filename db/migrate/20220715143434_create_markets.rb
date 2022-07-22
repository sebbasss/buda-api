class CreateMarkets < ActiveRecord::Migration[7.0]
  def change
    create_table :markets do |t|
      t.string :name
      t.string :spread
      t.string :alert_spread

      t.timestamps
    end
  end
end
