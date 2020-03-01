class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request
  
  def authenticate
    command = AuthenticateUser.call(params[:email].downcase!, params[:password])
    
    if command.success?
      msg = {
        auth_token: command.result[:auth_token], 
        first_name: command.result[:user].first_name, 
        last_name: command.result[:user].last_name, 
        email: command.result[:user].email
      }
      render json: msg
    else
      render json: { error: command.errors }, status: :unauthorized
    end
  end
end