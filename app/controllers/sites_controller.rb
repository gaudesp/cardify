class SitesController < ApplicationController
  def show
    @site = Site.includes(:pages, pages: :cards).find_by!(slug: params[:site_slug])

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
end
