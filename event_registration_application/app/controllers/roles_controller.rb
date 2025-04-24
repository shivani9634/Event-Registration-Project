class RolesController < ApplicationController
  def create
    @role = Role.new(role_params)
    if @role.save
      render json: @role, status: :created
    else
      render json: @role.errors, status: :unprocessable_entity
    end
  end

  def index
    @roles = Role.all
      render json: @roles
  end

  private

  def role_params
    params.require(:role).permit(:role_type)
  end
end
