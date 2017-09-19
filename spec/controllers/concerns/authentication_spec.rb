require 'rails_helper'

RSpec.describe Authentication, type: :controller do
  controller(ApplicationController) do
    before_action :require_user
    def show
      render json: { status: 'ok' }
    end
  end

  before do
    routes.draw { get 'fake' => 'anonymous#show' }
  end

  let(:user) { FactoryGirl.create(:user) }
  let(:access_token) { Token.new(user: user).encode }

  it 'requires user' do
    expect do
      get :show
    end.to raise_error(Authentication::Unauthorized)
  end

  it 'finds token from header' do
    request.headers['Authorization'] = "Bearer #{access_token}"
    get :show
    expect(response).to be_success
  end

  it 'finds token from params' do
    get :show, params: { access_token: access_token }
    expect(response).to be_success
  end
end
