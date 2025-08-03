module Public
  class SitesController < BaseController
    def index
      @sites = current_user.sites
    end
  end
end
