require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  it 'includes authentication' do
    expect(subject.class.ancestors.include?(Authentication)).to be true
  end
end
