class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :authorize_request
  attr_reader :current_user

  private

  def authorize_request
    header = request.headers["Authorization"]
    token = header.split(" ").last if header

    decoded = jwt_decode(token)
    @current_user = User.find_by(id: decoded[:user_id]) if decoded

    render json: { error: "Unauthorized" }, status: :unauthorized unless @current_user
  end

  # JWT encode method
  def jwt_encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, secret_key)
  end

  # JWT decode method
  def jwt_decode(token)
    decoded = JWT.decode(token, secret_key)[0]
    HashWithIndifferentAccess.new(decoded)
  rescue JWT::DecodeError
    nil
  end

  def secret_key
    Rails.application.secret_key_base || Rails.application.credentials.secret_key_base
  end

  # def require_role(*roles)
  #   unless roles.include?(@current_user.role)
  #     render json: { error: "Forbidden" }, status: :forbidden
  #   end
  # end
end
