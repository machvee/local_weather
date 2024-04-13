class WeatherCache
  CACHE_EXPIRATION = 30.minutes

  def self.fetch_from_address(address)
    Rails.cache.fetch(address_cache_key(address), expires_in: CACHE_EXPIRATION) do
      yield
    end
  end

  def self.fetch(id)
    Rails.cache.get(id)
  end

  def self.address_cache_key(address)
    "weather_for_#{address.key}"
  end
end
