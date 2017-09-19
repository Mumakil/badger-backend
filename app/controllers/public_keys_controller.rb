class PublicKeysController < ApplicationController
  def index
    @public_keys = [Token.public_key.to_s]
  end
end
