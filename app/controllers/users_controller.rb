class UsersController < ApplicationController
  before_action :set_user, only: [ :show, :update, :destroy ]
  skip_before_action :authorize_request, only: [ :login, :create, :show, :update, :index ]
  skip_load_and_authorize_resource only: [ :login, :create ]
  load_and_authorize_resource

  def login
    @user = User.find_by(email_id: params[:email_id])
    if @user && @user.authenticate(params[:password])
      token = jwt_encode(user_id: @user.id)
      render json: { token: token, role: @user.role.role_type }, status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  def index
    users = User.all
    render json: users
  end

  def show
    render json: @user
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: { message: "User created successfully", user: @user }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render json: { message: "User updated successfully", user: @user }
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    render json: { message: "User deleted successfully" }
  end

  private

  def user_params
    params.require(:user).permit(:name, :surname, :password, :phone_number, :email_id, :role_id)
  end
end
