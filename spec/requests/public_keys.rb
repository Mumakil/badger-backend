require 'rails_helper'

RSpec.describe 'public keys', type: :request do
  it 'shows index' do
    get '/public_keys'
    expect(response).to be_success
    expect(json_response).to have_length(1)
    expect(json_response.first).to match('BEGIN PUBLIC KEY')
  end
end
