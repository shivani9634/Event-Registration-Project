class DiscountCodesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_discount_code, only: [ :show, :update ]

  def create
    @discount_code = DiscountCode.new(discount_code_params)
    if @discount_code.save
      render json: @discount_code, status: :created
    else
      render json: @discount_code.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: @discount_code
  end

  def index
    @discount_codes = DiscountCode.all
    render json: @discount_codes
  end


  def update
    if @discount_code.update(discount_code_params)
      render json: @discount_code
    else
      render json: @discount_code.errors, status: :unprocessable_entity
    end
  end

  def event_discounts
    @discount_codes = DiscountCode.where(event_id: params[:event_id])
    render json: @discount_codes
  end

  private

  def set_discount_code
    @discount_code = DiscountCode.find_by(discount_code: params[:code])
  end

  def discount_code_params
    params.require(:discount_code).permit(:event_id, :discount_code, :discount_type, :discount_value, :valid_until, :valid_from, :max_uses, :current_uses, :is_active, :user_id)
  end
end
