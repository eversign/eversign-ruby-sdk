require 'spec_helper'

describe Eversign::Client do
  
  describe '#initializer' do
    it 'has a version number' do
      expect(Eversign::VERSION).not_to be nil
    end
  end
end
