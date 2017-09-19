module Authentication
  extend ActiveSupport::Concern

  class Unauthorized < StandardError; end

  included do
    helper_method :current_user
  end

  def require_user
    raise Unauthorized, 'Invalid or missing access token' if current_user.nil?
  end

  def current_user
    @current_user ||= begin
      access_token.try(:user)
    end
  end

  private

  def access_token
    @access_token ||= begin
      token_str = access_token_from_header
      token_str = access_token_from_param if token_str.blank?
      unless token_str.blank?
        Token.decode(token_str)
      end
    rescue Token::InvalidToken => e
      Rails.logger.info('Invalid authentication token', e)
    end
  end

  def access_token_from_header
    return nil if request.authorization.nil?
    return nil unless request.authorization.start_with?('Bearer ')
    request.authorization.sub('Bearer ', '').strip
  end

  def access_token_from_param
    return nil if params[:access_token].blank?
    params[:access_token].strip
  end
end
