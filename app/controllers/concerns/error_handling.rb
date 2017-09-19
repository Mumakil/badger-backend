module ErrorHandling
  extend ActiveSupport::Concern

  def render_error(message, status = 500)
    render json: { error: message }, status: status
  end
end
