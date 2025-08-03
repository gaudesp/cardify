module Admin
  class BaseController < ApplicationController
    layout 'admin'
    before_action :authenticate_user!

    include LoadSiteConcern
  end
end
