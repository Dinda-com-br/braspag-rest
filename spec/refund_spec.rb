require 'spec_helper'

describe BraspagRest::Refund do
  let(:refund) do
    {
      "Amount" => 1000,
      "Status" => 3,
      "ReceivedDate" => "2017-09-12T12:07:09.747"
    }
  end

  subject { described_class.new refund }

  it 'has an amount' do
    expect(subject.amount).to eq 1000
  end

  it 'has a status' do
    expect(subject.status).to eq 3
  end

  it 'has a received date' do
    expect(subject.received_date).to eq "2017-09-12T12:07:09.747"
  end

  describe '#success?' do
    it 'checks if the refund has a successfull status' do
      subject.status = 11
      expect(subject).to be_success

      subject.status = 10
      expect(subject).not_to be_success
    end
  end
end
