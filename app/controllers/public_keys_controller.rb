class PublicKeysController < ApplicationController
  before_action :default_format_json

  def index
    @public_keys = [Token.public_key.to_s]
  end
end
