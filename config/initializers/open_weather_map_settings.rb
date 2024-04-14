module OpenWeatherMapSettings
  UNITS = 'imperial'
  API_KEY = Rails.application.credentials.open_weather[:api_key]
end
