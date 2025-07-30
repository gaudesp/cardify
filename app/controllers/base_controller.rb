class BaseController < ApplicationController
  layout "application"

  def index
    @sites = current_user ? current_user.sites : Site.all
  end
end
