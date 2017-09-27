class AuthService
  attr_reader :authenticator, :user_creator, :token_creator

  Result = Struct.new('Result', :token)
  class AuthenticationFailed < ApplicationError::InvalidData; end

  def self.build(options)
    authenticator = case options[:auth_strategy]
                    when 'facebook'
                      AuthService::FacebookAuthenticator.build
                    else
                      AuthService::InvalidAuthenticator.build
                    end
    new(
      authenticator,
      AuthService::UserCreator.build,
      AuthService::TokenCreator.build
    )
  end

  def initialize(authenticator, user_creator, token_creator)
    @authenticator = authenticator
    @user_creator = user_creator
    @token_creator = token_creator
  end

  def call(params)
    access_token = params[:access_token]
    user_data = authenticator.call(access_token)
    user = user_creator.call(user_data)
    token = token_creator.call(user)
    Result.new(token)
  end
end
