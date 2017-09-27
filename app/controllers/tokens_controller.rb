class TokensController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    result = AuthService.build(auth_strategy: params[:strategy]).call(create_params)
    @token = result.token
  rescue ApplicationError::InvalidData => e
    render_error(e, :bad_request)
  end

  private

  def create_params
    params.permit(:access_token)
  end
end
