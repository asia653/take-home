class ApplicationController < ActionController::API
  include Pundit::Authorization

  before_action :authenticate

  rescue_from JWT::VerificationError, with: :invalid_token
  rescue_from JWT::DecodeError, with: :decode_error
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  rescue_from ActionController::ParameterMissing, with: :parameter_missing
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized


 
  private

  def user_not_authorized
    render json: { message: "you are not authorized to perform this action" }, status: 400
  end
 
  def authenticate
    @current_user ||= User.find(extract_user_id_from_jwt)
    return render(json: { message: "unauthorized access" }, status: 400) unless @current_user
  end

  def current_user
    @current_user ||= User.find(extract_user_id_from_jwt)
  end

  def extract_user_id_from_jwt
    authorization_header = request.headers['Authorization']
    token = authorization_header.split(" ").last if authorization_header
    decoded_token = JWT.decode(token, Rails.application.secret_key_base)[0]
    decoded_token["user_id"]
  end
 
  def invalid_token
    render json: { message: 'invalid token - there was an issue verifying this session' }, status: 400
  end
 
  def decode_error
    render json: { message: 'decode error - there was an issue verifying this session' }, status: 400
  end

  def record_not_found
    render json: { message: "record not found" }, status: 400
  end

  def parameter_missing
    render json: { message: "missing parameters, please try again" }, status: 400
  end
end
