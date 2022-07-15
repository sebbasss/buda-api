class CreateMarkets < ActiveRecord::Migration[7.0]
  def change
    create_table :markets do |t|
      t.string :name
      t.float :spread
      t.float :alert

      t.timestamps
    end
  end
end
