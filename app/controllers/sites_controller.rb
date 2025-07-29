class SitesController < ApplicationController
  before_action :set_site
  layout "site"

  def show
    @page =
      if params[:page_slug]
        @site.pages.find_by!(slug: params[:page_slug])
      else
        @site.pages.first!
      end

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  private

    def set_site
      @site = Site.includes(:pages, pages: :cards).find_by!(slug: params[:site_slug])
    end
end
