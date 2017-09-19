class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :default_format_json

  include Authentication
  include ErrorHandling

  def default_format_json
    request.format = 'json'
  end
end
