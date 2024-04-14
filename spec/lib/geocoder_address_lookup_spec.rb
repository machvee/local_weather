require 'rails_helper'

describe GeocoderAddressLookup do
  describe '.search' do
    let(:input_address) { instance_double("Address", to_s: '123 Main St, Anytown, USA', postal_code: '12345') }

    context 'when geocoding data is found' do
      before do
        geocoded_data = instance_double('Geocoder::Result::Opencagedata',
          data: {
            'geometry' => {'lat' => 38.96955, 'lng' => -77.3861},
            'components' => {
              'road' => '123 Main St',
              'city' => 'Herndon',
              'state' => 'Virginia',
              'country' => 'United States of America',
              'postcode' => '12345'
            }
          }
        )
        allow(geocoded_data).to receive(:street).and_return(geocoded_data.data['components']['road'])
        allow(geocoded_data).to receive(:city).and_return(geocoded_data.data['components']['city'])
        allow(geocoded_data).to receive(:state).and_return(geocoded_data.data['components']['state'])
        allow(geocoded_data).to receive(:country).and_return(geocoded_data.data['components']['country'])
        allow(geocoded_data).to receive(:latitude).and_return(geocoded_data.data['geometry']['lat'])
        allow(geocoded_data).to receive(:longitude).and_return(geocoded_data.data['geometry']['lng'])
        allow(geocoded_data).to receive(:postal_code).and_return(geocoded_data.data['components']['postcode'])

        allow(Geocoder).to receive(:search).and_return([geocoded_data])
      end

      it 'returns an Address object with correct attributes' do
        result = described_class.search(input_address)
        expect(result).to be_a(Address)
        expect(result.street).to eq('123 Main St')
        expect(result.city).to eq('Herndon')
        expect(result.state).to eq('Virginia')
        expect(result.postal_code).to eq('12345')
        expect(result.country).to eq('United States of America')
        expect(result.latitude).to eq(38.96955)
        expect(result.longitude).to eq(-77.3861)
      end
    end

    context 'when geocoding data is not found' do
      before do
        allow(Geocoder).to receive(:search).and_return([])
      end

      it 'returns nil' do
        result = described_class.search(input_address)
        expect(result).to be_nil
      end
    end
  end
end
