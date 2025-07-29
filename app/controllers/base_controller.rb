class BaseController < ApplicationController
  layout "application"

  def index
    @sites = Site.all
  end
end
