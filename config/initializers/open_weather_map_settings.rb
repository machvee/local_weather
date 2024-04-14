module OpenWeatherMapSettings
  UNITS = 'imperial'
  API_KEY = ENV['OPEN_WEATHER_MAP_API_KEY'] || Rails.application.credentials.open_weather[:api_key]
end
