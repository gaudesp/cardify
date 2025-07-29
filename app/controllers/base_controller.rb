class BaseController < ApplicationController
  def index
    @sites = Site.all
  end
end
