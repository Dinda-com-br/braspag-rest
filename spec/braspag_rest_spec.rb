require 'spec_helper'

describe BraspagRest do
  describe '.config' do
    it 'yields the current configuration object' do
      yielded = nil
      BraspagRest.config do |config|
        yielded = config
      end

      expect(yielded).to eq(BraspagRest.config)
    end
  end
end
