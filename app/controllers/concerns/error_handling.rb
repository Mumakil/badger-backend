module ErrorHandling
  extend ActiveSupport::Concern

  def render_error(message, status = 500)
    render json: { error: message }, status: status
  end

  def default_not_found(e)
    Rails.logger.warn('Default not found handler:', e)
    render_error('Not found', 404)
  end

  def default_unauthorized(e)
    render_error(e, 401)
  end
end
