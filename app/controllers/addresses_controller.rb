class AddressesController < ApplicationController
  layout 'logged_in'

  before_action :authenticate_user!

  def index
    if current_user.current_address
      @address = current_user.current_address
    else
      @address = Address.new
    end
  end

  def new
    if current_user.current_address && current_user.current_address.transactions.blank?
      @address = current_user.current_address
    else
      @address = Address.new
    end
  end

  def create
    if current_user.current_address && current_user.current_address.transactions.blank?
      @address = current_user.current_address
      @address.assign_attributes(address_params)
    else
      @address = Address.new(address_params.merge(user: current_user))
    end

    if @address.save
      current_user.update(current_address_id: @address.id) unless (current_user.current_address && current_user.current_address.transactions.blank?)
      redirect_to root_path, notice: "Address was successfully saved."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def address_params
    params.require(:address).permit(:line1, :line2, :city, :country, :postcode)
  end
end
