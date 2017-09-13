require 'faraday_middleware'

class FacebookAPI
  API_ENDPOINT = 'https://graph.facebook.com'.freeze
  PICTURE_TYPE = 'normal'.freeze

  class Error < RuntimeError; end
  class ApiError < Error; end
  class ConnectionError < Error; end

  attr_reader :access_token

  def initialize(access_token)
    @access_token = access_token
  end

  def me
    res = client.get('/me', fields: 'id,name')
    if res.status != 200
      raise ApiError, res.body['error']['message']
    end
    res.body
  rescue Faraday::Error => e
    raise ConnectionError, e
  end

  def self.avatar_url(id)
    "https://graph.facebook.com/#{id}/picture?type=#{PICTURE_TYPE}"
  end

  private

  def client
    @client ||= Faraday.new(url: API_ENDPOINT) do |conn|
      conn.request :oauth2, access_token, token_type: 'bearer'
      conn.request :json
      conn.response :json, content_type: /\bjson$/
      conn.adapter Faraday.default_adapter
    end
  end
end
