class V1::UsersController < ApplicationController
  skip_before_action :authenticate

  def login
    @user = User.find_by(email: params[:email].downcase)
    if @user && @user.authenticate(params[:password]) 
      @token = JWT.encode({ user_id: @user.id }, Rails.application.secret_key_base)
      render json: { message: "successfully logged in", token: @token }, status: 200
    else
      render json: { message: "incorrect credentials" }, status: 400
    end


  end

  def signup
    @user = User.new(user_params)
    @user_saved = @user.save
    if @user_saved
      @token = JWT.encode({ user_id: @user.id }, Rails.application.secret_key_base)
      render json: { message: "user has been registered", token: @token }, status: 200
    else
      render json: { message: "there was an issue registering the user", errors: @user.errors }, status: 400
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password)
    end
end
