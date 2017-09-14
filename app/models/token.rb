require 'jwt'

class Token
  class InvalidToken < RuntimeError; end

  class_attribute :rsa_key

  RSA_ALGORITHM = 'RS512'.freeze

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
    JWT.encode payload, self.class.private_key, RSA_ALGORITHM
  end

  def self.decode(token)
    data, = JWT.decode(
      token,
      public_key,
      true,
      algorithm: RSA_ALGORITHM,
      verify_iat: true,
      verify_sub: true
    )
    Token.new(user_id: data['subject'])
  rescue JWT::DecodeError => e
    raise InvalidToken, e
  end

  def self.private_key
    rsa_key
  end

  def self.public_key
    rsa_key.public_key
  end
end
