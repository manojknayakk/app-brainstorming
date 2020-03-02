class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [:create]

  def is_valid
    @user = User.where(:email => params[:email].downcase).where.not(:id => @current_user.id).first
    if !@user.blank?
      msg = {
        id: @user.id, 
        first_name: @user.first_name, 
        last_name: @user.last_name, 
        email: @user.email,
        is_valid: true
      }
      render json: msg
    else
      msg = {
        is_valid: false
      }
      render json: msg
    end
  end
  
  def create
    @user = User.new(user_params)
    
    if @user.save
      command = AuthenticateUser.call(@user.email, user_params[:password])
      msg = {
        auth_token: command.result[:auth_token], 
        first_name: command.result[:user].first_name, 
        last_name: command.result[:user].last_name, 
        email: command.result[:user].email
      }
      render json: msg, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
end
