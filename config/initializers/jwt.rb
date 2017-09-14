require 'openssl'

raw_key = Rails.application.secrets.jwt_rsa_key.strip
if raw_key.blank?
  raise 'No jwt key configured'
end
rsa_key = OpenSSL::PKey::RSA.new(raw_key)
Token.rsa_key = rsa_key
