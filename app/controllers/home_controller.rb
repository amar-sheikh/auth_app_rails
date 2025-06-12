class HomeController < ApplicationController
  before_action :authenticate_user!
  layout 'logged_in'

  def index
  end
end
