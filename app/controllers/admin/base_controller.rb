module Admin
  class BaseController < ApplicationController
    layout 'admin'
    before_action :authenticate_user!

    include LoadSiteConcern
    before_action :autorize_user!

    private

    def autorize_user!
      head :forbidden unless current_site.user_id == current_user.id
    end
  end
end
