module ErrorHandling
  extend ActiveSupport::Concern

  def render_error(message, status = 500)
    render json: { error: message }, status: status
  end

  def default_not_found(e)
    render_error(e, :not_found)
  end

  def default_unauthorized(e)
    render_error(e, :unauthorized)
  end
end
