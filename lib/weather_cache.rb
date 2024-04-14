class WeatherCache
  #
  # Caches Weather object in Rails.cache given the passed Address
  # The Address#key (postal_code) is the discriminating
  # component in the Cache key.
  #
  CACHE_EXPIRATION = 30.minutes

  def self.fetch_weather_at_location(address)
    Rails.cache.fetch(cache_key(address.key), expires_in: CACHE_EXPIRATION) do
      yield # to Weather Searcher
    end
  end

  def self.read_weather_for(key)
    Rails.cache.read(cache_key(key))
  end

  def self.cache_key(key)
    "weather_at_#{key}"
  end
end
