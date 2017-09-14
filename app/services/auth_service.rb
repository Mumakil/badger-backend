class AuthService
  class AuthenticationFailed < RuntimeError; end

  attr_reader :authenticator, :user_creator, :token_creator

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
    ServiceResult.new(success: true, token: token)
  rescue AuthenticationFailed => e
    ServiceResult.new(success: false, error: e, status_hint: 400)
  rescue ActiveRecord::RecordInvalid => e
    ServiceResult.new(success: false, error: e, status_hint: 400)
  rescue RuntimeError => e
    ServiceResult.new(success: false, error: e)
  end
end
