require 'rails_helper'

RSpec.describe Code, type: :model do
  describe '#generate' do
    it 'generates a code with specified length' do
      expect(Code.generate(5).length).to be(5)
    end
  end
end
