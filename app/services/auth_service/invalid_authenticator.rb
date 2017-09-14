class AuthService
  class InvalidAuthenticator
    def self.build
      new
    end

    def call
      raise ::AuthService::AuthenticationFailed, 'Invalid authentication strategy'
    end
  end
end
