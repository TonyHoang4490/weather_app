module OpenWeatherMapHelper

  def self.get_weather_forecast(address)
  	lat_long = get_lat_long_from_address(address)
  	# forecast api requests by city and zipcodes have been deprecated.  That is why we need to use the api with lat/long (extra work)
  	get_weather_forecast_from_lat_long(lat_long[:lat], lat_long[:long])
  end

  private

  #'http://api.openweathermap.org/geo/1.0/zip?zip={zip code},{country code}&appid={API key}
  #'http://api.openweathermap.org/geo/1.0/direct?q={city name},{state code},{country code}&limit={limit}&appid={API key}'
  #'http://api.openweathermap.org/data/2.5/forecast?lat={lat}&lon={lon}&appid={API key}'

  API_KEY = 'e915d5a7a6079a0bb717d2466c46dafe'.freeze  # In prod, this api key should be hidden in a vault such as AWS Secret Manager.
  BASE_GEO_BY_CITY_STATE_URL = 'http://api.openweathermap.org/geo/1.0/direct?'.freeze
  BASE_GEO_BY_ZIP_URL = 'http://api.openweathermap.org/geo/1.0/zip?units=imperial&'.freeze
  BASE_FORECAST_URL = 'http://api.openweathermap.org/data/2.5/forecast?units=imperial&'.freeze

  def self.get_weather_forecast_from_lat_long(lat, long)
    url = "#{BASE_FORECAST_URL}lat=#{lat}&lon=#{long}&appid=#{API_KEY}"
    data = {}
  	begin
  	  data = JSON.parse(RestClient.get(url))
  	rescue => e
 		   # exception handling here
  	end
  	gen_weather_data_for_app(data)  # The app should store its own meta data, instead of third-party service's raw data, in case it uses different service later.
  end

  def self.get_lat_long_from_address(address)
  	lat_long = {}
  	if address.zip_code.present?
  		lat_long = get_lat_long_from_zip_code(address.zip_code)
  	elsif address.city.present?
  		lat_long = get_lat_long_from_city_state(address.city, address.state)
  	end
    lat_long
  end

  def self.get_lat_long_from_zip_code(zip_code)
	  lat_long = {}
  	url = "#{BASE_GEO_BY_ZIP_URL}zip=#{zip_code},US&appid=#{API_KEY}"
  	begin
  	  data = JSON.parse(RestClient.get(url))
  	  lat_long = {lat: data['lat'], long: data['lon']}
  	rescue => e
  	  		# exception handling here
  	end
  	lat_long
  end

  def self.get_lat_long_from_city_state(city, state=nil)
  	city_state = city
  	city_state += ", #{state}" unless state.blank?  # state is optional
  	url = "#{BASE_GEO_BY_CITY_STATE_URL}q=#{city_state},US&appid=#{API_KEY}"

	  lat_long = {}
  	begin
  	  data = JSON.parse(RestClient.get(url))
  	  lat_long = {lat: data.first['lat'], long: data.first['lon']}
  	rescue => e
  	  		# exception handling here
  	end
  	lat_long
  end

  # Converting raw data into meta data for this app
  def self.gen_weather_data_for_app(data)
    return [] if data['list'].blank?
  	weather_list = data['list'].first(16).map do |item|
  		{
  		  'time'=> DateTime.parse(item['dt_txt']).in_time_zone("Pacific Time (US & Canada)"),
  		  'temp'=> item['main']['temp'],
  		  'temp_high'=> item['main']['temp_max'],
  		  'temp_low'=> item['main']['temp_min'],
  		  'weather_desc'=> item['weather'].first['description'],
  		  'weather_OWM_icon_code'=> item['weather'].first['icon'],   # EX: http://openweathermap.org/img/w/10d.png  for openWeatherMap icon's value = '10d'
        'wind'=> item['wind']['speed'],
        'humidity'=> item['main']['humidity']
      }
  	end
  end

end
