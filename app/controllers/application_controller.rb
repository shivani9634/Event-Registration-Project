class ApplicationController < ActionController::API
  include CanCan::ControllerAdditions
  before_action :authorize_request, except: [ :login, :create ]
  skip_authorize_resource only: [ :create ]

  rescue_from CanCan::AccessDenied do |exception|
    render json: { error: "Access denied: " }, status: :forbidden
  end

  private


  def authorize_request
    header = request.headers["Authorization"]
    token = header.split(" ").last if header
    decoded = jwt_decode(token)

    if decoded && !JtiBlacklist.blacklisted?(decoded[:jti])
      @current_user = User.find_by(id: decoded[:user_id])
    end

    render json: { error: "Unauthorized" }, status: :unauthorized unless @current_user
  end

  def current_user
    @current_user
  end

  def jwt_encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    payload[:jti] = SecureRandom.uuid   # add jti
    JWT.encode(payload, secret_key)
  end


  def jwt_decode(token)
    decoded = JWT.decode(token, secret_key)[0]
    HashWithIndifferentAccess.new(decoded)
  rescue JWT::DecodeError
    nil
  end

  def secret_key
    Rails.application.secret_key_base || Rails.application.credentials.secret_key_base
  end
end
