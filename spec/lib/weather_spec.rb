require 'rails_helper'

describe Weather do
  describe '#initialize' do
    let(:weather) do
      Weather.new(
        postal_code: '12345',
        temperature: 77.0,
        min_temperature: 68.0,
        max_temperature: 82.0,
        humidity: 50
      )
    end

    it 'correctly assigns postal_code' do
      expect(weather.postal_code).to eq('12345')
    end

    it 'correctly assigns temperature' do
      expect(weather.temperature).to eq(77.0)
    end

    it 'correctly assigns min_temperature' do
      expect(weather.min_temperature).to eq(68.0)
    end

    it 'correctly assigns max_temperature' do
      expect(weather.max_temperature).to eq(82.0)
    end

    it 'correctly assigns humidity' do
      expect(weather.humidity).to eq(50)
    end

    it 'correctly assigns the current time to timestamp' do
      # Assuming the timestamp should be close to the current time
      expect(weather.timestamp).to be_within(1.minute).of Time.current
    end
  end
end

