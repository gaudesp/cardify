module Public
  class SitesController < BaseController
    before_action :authenticate_user!

    def index
      @sites = current_user.sites
    end
  end
end
