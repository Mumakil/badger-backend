require 'jwt'

class Token
  class InvalidToken < RuntimeError; end

  HMAC_ALGORITHM = 'HS256'.freeze

  def initialize(options)
    @user = options[:user]
    @user_id = options[:user_id]
  end

  def payload
    now = Time.now.to_i
    { subject: user.id, iat: now, nbf: now }
  end

  def user
    @user || User.find(@user_id)
  end

  def user_id
    @user_id || @user.id
  end

  def encode
    JWT.encode payload, self.class.secret, HMAC_ALGORITHM
  end

  def self.decode(token)
    data, = JWT.decode(
      token,
      secret,
      true,
      algorithm: HMAC_ALGORITHM,
      verify_iat: true,
      verify_sub: true
    )
    Token.new(user_id: data['subject'])
  rescue JWT::DecodeError => e
    raise InvalidToken, e
  end

  def self.secret
    Rails.application.secrets.secret_key_base
  end
end
