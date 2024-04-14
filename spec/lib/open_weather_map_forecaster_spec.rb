require 'rails_helper'

describe OpenWeatherMapForecaster do
  describe '.search' do
    let(:valid_address) { instance_double("Address", latitude: 25.7912, longitude: -80.1445, key: '33139') }
    let(:api_key) { 'your_api_key_here' }
    let(:url) { "http://api.openweathermap.org/data/2.5/weather" }
    let(:query_params) {
      {
        lat: valid_address.latitude,
        lon: valid_address.longitude,
        appid: api_key,
        units: 'imperial'
      }
    }

    let(:response_body) do
      {
        "coord" => {"lon" => -80.1445, "lat" => 25.7912},
        "weather" => [{"id" => 801, "main" => "Clouds", "description" => "few clouds", "icon" => "02d"}],
        "main" => {"temp" => 78.55, "feels_like" => 78.55, "temp_min" => 76.01, "temp_max" => 81, "pressure" => 1021, "humidity" => 52},
        "visibility" => 10000,
        "dt" => 1713122628,
        "sys" => {"type" => 2, "id" => 2009372, "country" => "US", "sunrise" => 1713092274, "sunset" => 1713138186},
        "timezone" => -14400,
        "id" => 4164143,
        "name" => "Miami Beach",
        "cod" => 200
      }.to_json
    end

    before do
      stub_request(:get, described_class::OPEN_WEATHER_MAP_API_URL)
        .with(query: hash_including({appid: Rails.application.credentials.open_weather[:api_key]}))
        .to_return(status: 200, body: response_body, headers: { 'Content-Type' => 'application/json' })
    end
    
    it 'returns a Weather object with correct attributes' do
      result = described_class.search(valid_address)
      expect(result).to be_a(Weather)
      expect(result.postal_code).to eq('33139')
      expect(result.temperature).to eq(78.55)
      expect(result.min_temperature).to eq(76.01)
      expect(result.max_temperature).to eq(81)
      expect(result.humidity).to eq(52)
    end
  end
end

