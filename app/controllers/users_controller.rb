class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [:create]
  before_action :set_user, only: [:show, :update, :destroy]

  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # Post /users/is_valid
  def is_valid
    @user = User.where(:email => params[:email].downcase!).where.not(:id => @current_user.id).first
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

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      command = AuthenticateUser.call(user_params[:email].downcase!, user_params[:password])
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

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
    end
end
