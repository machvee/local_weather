require 'rails_helper'

describe Address, type: :model do
  subject { described_class.new(attributes) }

  let(:valid_attributes) {
    {
      street: '123 Main St',
      city: 'Miami Beach',
      state: 'FL',
      postal_code: '12345'
    }
  }

  context 'validations' do
    context 'when attributes are valid' do
      let(:attributes) { valid_attributes }

      it 'is valid with valid attributes' do
        expect(subject).to be_valid
      end
    end

    context 'when city is missing' do
      let(:attributes) { valid_attributes.except(:city) }

      it 'is not valid without a city' do
        expect(subject).to_not be_valid
        expect(subject.errors[:city]).to include("can't be blank")
      end
    end

    context 'when state is missing' do
      let(:attributes) { valid_attributes.except(:state) }

      it 'is not valid without a state' do
        expect(subject).to_not be_valid
        expect(subject.errors[:state]).to include("can't be blank")
      end
    end

    context 'with an invalid postal code' do
      let(:attributes) { valid_attributes.merge(postal_code: 'invalid') }

      it 'is not valid with an invalid postal code' do
        expect(subject).to_not be_valid
        expect(subject.errors[:postal_code]).to include('must be a valid ZIP code')
      end
    end
  end

  describe '#to_s' do
    let(:attributes) { valid_attributes }

    it 'returns a formatted address string' do
      expect(subject.to_s).to eq('123 Main St, Miami Beach, FL, 12345')
    end

    context 'without a postal code' do
      let(:attributes) { valid_attributes.except(:postal_code) }

      it 'returns a formatted address string without a postal code' do
        expect(subject.to_s).to eq('123 Main St, Miami Beach, FL')
      end
    end
  end

  describe '#key' do
    context 'when postal_code is present' do
      let(:attributes) { valid_attributes }

      it 'returns the postal code' do
        expect(subject.key).to eq('12345')
      end
    end

    context 'when postal_code is not present' do
      let(:attributes) { valid_attributes.except(:postal_code) }

      it 'returns a combination of city and state' do
        expect(subject.key).to eq('Miami_Beach_FL')
      end
    end
  end
end
