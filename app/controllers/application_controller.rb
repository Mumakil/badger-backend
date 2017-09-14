class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def render_error(result)
    render json: { error: result.error }, status: (result.status_hint || 500)
  end

  def default_format_json
    request.format = 'json'
  end
end
