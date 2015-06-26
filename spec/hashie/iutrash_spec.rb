require 'spec_helper'

class Address < Hashie::IUTrash
  property :street, from: 'Street'
  property :number, from: 'Number'
end

class Person < Hashie::IUTrash
  property :name, from: 'Name'
  property :phone, from: 'Telephone'
  property :main_address, from: 'MainAddress', with: ->(values) { Address.new(values) }
end

describe Hashie::IUTrash do
  let(:params) { { 'Name' => 'foo', 'Telephone' => 123, 'MainAddress' => { 'Street' => 'Rua 1', 'Number' => 123 } } }

  subject(:person) { Person.new(params) }

  it 'translates parameters according to declared on class' do
    expect(person.name).to eq('foo')
    expect(person.phone).to eq(123)
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
  end

  describe '#build' do
    let(:params) { { name: 'bar', phone: 321, main_address: { street: 'Rua 2', number: 321 } } }

    subject(:person) { Person.build(params) }

    it 'builds an object using original properties instead translations' do
      expect(person.name).to eq('bar')
      expect(person.phone).to eq(321)
      expect(person.main_address.street).to eq('Rua 2')
      expect(person.main_address.number).to eq(321)
    end
  end
end
