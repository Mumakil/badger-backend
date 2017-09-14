class TokensController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :default_format_json

  def create
    result = AuthService.build(auth_strategy: params[:strategy]).call(create_params)
    if result.success?
      @token = result.token
    else
      render_error(result)
    end
  end

  private

  def create_params
    params.permit(:access_token)
  end
end
