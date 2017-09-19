class StaticController < ApplicationController
  skip_before_action :default_format_json

  def index; end
end
