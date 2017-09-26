require 'rails_helper'

RSpec.describe 'static pages', type: :request do
  it 'show index' do
    get '/'
    expect(response).to be_success
  end

  it 'displays a reasonable error for invalid routes' do
    get "/#{SecureRandom.urlsafe_base64}"
    expect(response).to have_http_status :not_found
  end

  it 'displays a reasonable error for invalid method' do
    post '/'
    expect(response).to have_http_status :not_found
    post '/public_keys'
    expect(response).to have_http_status :not_found
  end
end
