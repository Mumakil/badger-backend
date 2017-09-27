class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :default_format_json

  include Authentication
  include ErrorHandling

  rescue_from ActiveRecord::RecordNotFound, with: :default_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :default_invalid
  rescue_from Authentication::InvalidAuthentication, with: :default_unauthorized
  rescue_from ApplicationError::Unauthorized, with: :default_unauthorized
  rescue_from ApplicationError::Forbidden, with: :default_forbidden

  def default_format_json
    request.format = 'json'
  end

  def no_route_found
    render_error('Resource not found', 404)
  end
end
