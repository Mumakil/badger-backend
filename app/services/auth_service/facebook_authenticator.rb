require 'facebook_api'

class AuthService
  class FacebookAuthenticator
    def self.build
      new
    end

    def call(access_token)
      data = FacebookAPI.new(access_token).me
      {
        fbid: data['id'],
        name: data['name'],
        avatar_url: FacebookAPI.avatar_url(data['id'])
      }
    rescue FacebookAPI::ApiError => e
      raise ::AuthService::AuthenticationFailed, e
    end
  end
end
