class OpenWeatherMapForecaster
  OPEN_WEATHER_MAP_API_URL = 'http://api.openweathermap.org/data/2.5/weather'
  
  def self.search(postal_code, latitude, longitude)
    response = HTTParty.get(
      OPEN_WEATHER_MAP_API_URL,
      query: {
        lat: latitude,
        lon: longitude,
        appid: OpenWeatherMapSettings::API_KEY,
        units: OpenWeatherMapSettings::UNITS
      }
    )

    return nil unless response.success?

    main_weather_info = response.parsed_response["main"]
    temperature = main_weather_info["temp"]
    humidity = main_weather_info["humidity"]

    Weather.new(postal_code: postal_code, temperature: temperature, humidity: humidity)
  end
end
