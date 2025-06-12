class Users::ProfilesController < ApplicationController
  before_action :authenticate_user!
  layout 'logged_in'
  before_action :set_user, only: [:edit, :update]

  def edit;end

  def update
    email_changed = @user.email != user_params[:email]

    if @user.update_with_password(user_params)
      if email_changed
        @user.send_confirmation_instructions
        @user.confirmed_at = nil
        @user.save(validate: false)
      end

      redirect_to root_path, notice: "Profile updated successfully."
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password)
  end

  def set_user
    @user = current_user
  end
end
