class WeatherForecaster

  attr_reader :address, :geocoder, :forecaster

  def self.call(address, geocoder: GeocoderAddressLookup, forecaster: OpenWeatherMapForecaster )
    new(address, geocoder: geocoder, forecaster: forecaster).call
  end

  def initialize(address, geocoder:, forecaster:)
    @address = address
    @geocoder = geocoder
    @forecaster = forecaster
  end

  def call
    located_address = geocoder.search(address)
    return nil if located_address.nil?

    WeatherCache.fetch_from_address(located_address) do
      forecaster.search(
        located_address.postal_code,
        located_address.latitude,
        located_address.longitude
      )
    end
  end
end
