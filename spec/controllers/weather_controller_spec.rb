require 'rails_helper'

describe WeatherController, type: :controller do
  describe 'POST #create' do
    let(:valid_attributes) {
      { street: '123 Main St', city: 'Anytown', state: 'Anystate', postal_code: '12345' }
    }

    context 'when the address is valid and weather data is available' do
      let(:weather) { instance_double('Weather', postal_code: '12345', temperature: 70) }

      before do
        allow(WeatherForecaster).to receive(:call).and_return(weather)
        post :create, params: { address: valid_attributes }
      end

      it 'calls WeatherForecaster with an address' do
        expect(WeatherForecaster).to have_received(:call).with(instance_of(Address))
      end

      it 'redirects to the show action with the correct postal code' do
        expect(response).to redirect_to(action: :show, id: '12345')
      end
    end

    context 'when the address is valid but weather data is not available' do
      before do
        allow(WeatherForecaster).to receive(:call).and_return(nil)
        post :create, params: { address: valid_attributes }
      end

      it 'redirects to new with a notice about unavailable weather' do
        expect(response).to redirect_to(new_weather_path)
        expect(flash[:notice]).to match(/Not available at/)
      end
    end
  end

  describe 'GET #show' do
    let(:weather) { instance_double('Weather', postal_code: '12345', temperature: 75, timestamp: 1.hour.ago) }

    before do
      allow(WeatherCache).to receive(:read_weather_for).with('12345').and_return(weather)
      get :show, params: { id: '12345' }
    end

    it 'fetches weather data and assigns it to @weather' do
      expect(assigns(:weather)).to eq(weather)
    end
  end
end
