require 'rails_helper'

describe WeatherForecaster do
  describe '.call' do
    let(:address_query) { Address.new(street: '123 AnyBlvd', city: 'Anytown', state: 'FL') }
    let(:geocoder) { class_double('GeocoderAddressLookup') }
    let(:forecaster) { class_double('OpenWeatherMapForecaster') }
    let(:address) { instance_double('Address', key: '12345') }

    context 'when the address is successfully located' do
      let(:weather) { instance_double('Weather', temperature: 70) }

      before do
        allow(geocoder).to receive(:search).with(address_query).and_return(address)
        allow(forecaster).to receive(:search).with(address).and_return(weather)
        allow(WeatherCache).to receive(:fetch_weather_at_location).with(address).and_yield.and_return(weather)
      end

      it 'returns the weather object' do
        result = described_class.call(address_query, geocoder: geocoder, forecaster: forecaster)
        expect(result).to eq(weather)
      end
    end

    context 'when the address is not found' do
      before do
        allow(geocoder).to receive(:search).with(address_query).and_return(nil)
      end

      it 'returns nil' do
        result = described_class.call(address_query, geocoder: geocoder, forecaster: forecaster)
        expect(result).to be_nil
      end
    end
  end
end
