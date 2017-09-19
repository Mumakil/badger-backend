class TokensController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    result = AuthService.build(auth_strategy: params[:strategy]).call(create_params)
    if result.success?
      @token = result.token
    else
      render_error(result.error, result.status_hint)
    end
  end

  private

  def create_params
    params.permit(:access_token)
  end
end
