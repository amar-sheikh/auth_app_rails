class Users::ProfilesController < ApplicationController
  before_action :authenticate_user!
  layout 'logged_in'

  before_action :set_user, only: [:edit, :update]
  after_action :invalidate_sessions, only: [:update]

  def edit;end

  def update
    email_changed = @user.email != user_params[:email]

    successfully_updated = if user_params[:password].blank?
                             @user.update_without_password(user_params.slice(:email))
                           else
                             @user.update_with_password(user_params)
                           end


    if successfully_updated
      if email_changed
        @user.update_columns(confirmed_at: nil)
        @user.send_confirmation_instructions
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

  def invalidate_sessions
    @user.forget_me! if @user.saved_change_to_encrypted_password? && params[:log_out_of_all_devices] == '1'
  end
end
