module WeathersHelper
  CACHE_EXPIRY = 30.minutes  #Cache the forecast details for 30 minutes for all subsequent requests by zip codes.

  # This is the interface which currently uses 'Open Weather Map' service to gather weather forecast info
  # but we can switch to different services in the future as long as the raw data can be converted to our meta data.
  #
  # Meta Data for weather forecast
  #   [
  #   	{
  #       'time'=> <DateTime>,                  # PST  timezone
  #       'temp'=> <float>,                     # in Fahrenheit
  #       'temp_high'=> <float>,                # in Fahrenheit
  #       'temp_low'=> <float>,                 # in Fahrenheit
  #       'weather_desc'=> <string>,            # such as 'cloudy', 'rain', 'clear sky', etc .....
  #       'weather_OWM_icon_code'=> <string>,   # EX: http://openweathermap.org/img/w/10d.png  for openWeatherMap icon's value = '10d'
  #       'wind'=> <float>,                     # in Mile/Hour
  #       'humidity'=> <integer>                # percentage
  #     },...
  #   ]
  # Return:   <data>, <is_cached_flag>
	def self.get_weather_forecast(address)
    return [OpenWeatherMapHelper.get_weather_forecast(address), false] if address.zip_code.blank?

    # Try to obtain from cache
    data = RedisHelper.get(address.zip_code)
    return [JSON.parse(data), true] if data.present?

    data = OpenWeatherMapHelper.get_weather_forecast(address)
    RedisHelper.set(address.zip_code, data.to_json, CACHE_EXPIRY) if data.present?

    [data, false]
  end

end
