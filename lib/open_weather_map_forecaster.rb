class OpenWeatherMapForecaster
  OPEN_WEATHER_MAP_API_URL = 'http://api.openweathermap.org/data/2.5/weather'
  
  def self.search(valid_address)
    response = HTTParty.get(
      OPEN_WEATHER_MAP_API_URL,
      query: {
        lat: valid_address.latitude,
        lon: valid_address.longitude,
        appid: OpenWeatherMapSettings::API_KEY,
        units: OpenWeatherMapSettings::UNITS
      }
    )

    return nil unless response.success?

    main_weather_info = response.parsed_response["main"]
    temperature = main_weather_info["temp"]
    humidity = main_weather_info["humidity"]

    Weather.new(
      postal_code: valid_address.key,
      temperature: temperature,
      humidity: humidity
    )
  end
end
