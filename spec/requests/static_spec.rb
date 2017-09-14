require 'rails_helper'

RSpec.describe 'static pages', type: :request do
  it 'show index' do
    get '/'
    expect(response).to be_success
  end
end
