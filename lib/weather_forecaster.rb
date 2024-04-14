class WeatherForecaster
  #
  # pass in address to search, plus optional geocoder and forecaster dependencies
  # returns nil if not found, otherwise forecaster.search Weather response is cached
  # and returned
  #
  attr_reader :address_query, :geocoder, :forecaster

  def self.call(address_query, geocoder: GeocoderAddressLookup, forecaster: OpenWeatherMapForecaster)
    new(address_query, geocoder: geocoder, forecaster: forecaster).call
  end

  def initialize(address_query, geocoder:, forecaster:)
    @address_query = address_query
    @geocoder = geocoder
    @forecaster = forecaster
  end

  def call
    located_address = geocoder.search(address_query)
    return nil if located_address.nil?

    WeatherCache.fetch_weather_at_location(located_address) do
      forecaster.search(located_address)
    end
  end
end
