class AddApiKeyToWeatherWidget < ActiveRecord::Migration
  def change
    add_column :weather_widgets, :api_key, :string
  end
end
