class AuthService
  class TokenCreator
    def self.build
      new
    end

    def call(user)
      Token.new(user: user)
    end
  end
end
