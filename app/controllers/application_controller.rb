class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :default_format_json

  include Authentication
  include ErrorHandling

  rescue_from ActiveRecord::RecordNotFound, with: :default_not_found
  rescue_from Authentication::Unauthorized, with: :default_unauthorized

  def default_format_json
    request.format = 'json'
  end
end
