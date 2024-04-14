require 'rails_helper'

describe WeatherCache do
  let(:key) { '12345' }
  let(:weather_data) do
    Weather.new(
      postal_code: key,
      temperature: 70.3,
      min_temperature: 68.4,
      max_temperature: 81.0,
      humidity: 55
    )
  end

  shared_examples_for 'cached weather equality' do
    it 'reads cached weather data for a given key' do
      expect(cached_weather.postal_code).to eq(weather_data.postal_code)
      expect(cached_weather.temperature).to eq(weather_data.temperature)
      expect(cached_weather.min_temperature).to eq(weather_data.min_temperature)
      expect(cached_weather.max_temperature).to eq(weather_data.max_temperature)
      expect(cached_weather.humidity).to eq(weather_data.humidity)
    end
  end

  describe '.fetch_weather_at_location' do
    let(:address) { instance_double("Address", key: key) }
    let(:result) do
      described_class.fetch_weather_at_location(address) do
        weather_data
      end
    end

    it 'caches weather data for a given address key' do
      expect(result).to eq(weather_data)
    end

    it_behaves_like 'cached weather equality' do
      let(:cached_weather) { Rails.cache.read("weather_at_#{address.key}") }
    end
  end

  describe '.read_weather_for' do
    let(:cached_weather) { weather_data }

    before do
      Rails.cache.write("weather_at_#{key}", cached_weather)
    end

    it_behaves_like 'cached weather equality' do
      let(:cached_weather) { described_class.read_weather_for(key) }
    end

  end

  describe '.cache_key' do
    let(:key) { '67890' }

    it 'returns the correct cache key' do
      expect(described_class.cache_key(key)).to eq("weather_at_#{key}")
    end
  end
end
