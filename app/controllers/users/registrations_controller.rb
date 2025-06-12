class Users::RegistrationsController < Devise::RegistrationsController

  protected

  def sign_up(resource_name, resource)
    resource.send_confirmation_instructions
  end
end
