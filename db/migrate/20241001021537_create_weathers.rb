class CreateWeathers < ActiveRecord::Migration[7.2]
  def change
    create_table :weathers do |t|
      t.datetime :time
      t.float :temp
      t.float :temp_high
      t.float :temp_low
      t.string :weather_desc
      t.string :weather_OWM_icon_code
      t.float :wind
      t.integer :humidity

      t.timestamps
    end
  end
end
