require 'spec_helper'

class Address < Hashie::IUTrash
  property :street, from: 'Street'
  property :number, from: 'Number'
end

class Phone < Hashie::IUTrash
  property :code, from: 'Code'
  property :number, from: 'Number'
end

class Person < Hashie::IUTrash
  include Hashie::Extensions::Coercion

  property :name, from: 'Name'
  property :phones, from: 'Telephones'
  property :main_address, from: 'MainAddress', with: ->(values) { Address.new(values) }

  coerce_key :phones, Array[Phone]
end

describe Hashie::IUTrash do
  let(:params) do
    {
      'Name' => 'foo',
      'MainAddress' => { 'Street' => 'Rua 1', 'Number' => 123 }
    }
  end

  subject(:person) { Person.new(params) }

  it 'translates parameters according to declared on class' do
    expect(person.name).to eq('foo')
    expect(person.main_address.street).to eq('Rua 1')
    expect(person.main_address.number).to eq(123)
  end

  it 'ignores undeclared parameters' do
    expect(Person.new('Weight' => 65)).to be_an_instance_of(Person)
  end

  describe '#inverse_attributes' do
    it 'returns a hash with their properties using inverse translated' do
      expect(person.inverse_attributes).to eq(params)
    end

    it 'nested inverse attributes' do
      params['Telephones'] = [
         { :code => '+55', :number => '555-555' },
         { :code => '+1', :number => '222-222' }
      ]
      person = Person.new(params)

      expect(person.inverse_attributes).to eq(params)
    end
  end
end
