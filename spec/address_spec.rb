require 'spec_helper'

describe BraspagRest::Address do
  let(:braspag_response) {
    {
      'Street' => 'Alameda Xingu',
      'Number' => '512',
      'Complement' => '27 andar',
      'ZipCode' => '12345987',
      'City' => 'São Paulo',
      'State' => 'SP',
      'Country' => 'BRA',
      'District' => 'Alphaville'
    }
  }

  describe '.new' do
    subject(:address) { BraspagRest::Address.new(braspag_response) }

    it 'initializes an address using braspag response format' do
      expect(address.street).to eq('Alameda Xingu')
      expect(address.number).to eq('512')
      expect(address.complement).to eq('27 andar')
      expect(address.zipcode).to eq('12345987')
      expect(address.city).to eq('São Paulo')
      expect(address.state).to eq('SP')
      expect(address.country).to eq('BRA')
      expect(address.district).to eq('Alphaville')
    end
  end
end
