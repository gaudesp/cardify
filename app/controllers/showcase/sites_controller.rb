module Showcase
  class SitesController < BaseController
    def show
      @is_mobile = mobile_device?

      if @is_mobile
        @pages = current_site.pages.order(:position)
        puts "\n\n==== A\n\n"
      else
        @page =
          if params[:page_slug]
            puts "\n\n==== B\n\n"
            current_site.pages.find_by!(slug: params[:page_slug])
          else
            puts "\n\n==== C\n\n"
            current_site.pages.first!
          end
      end

      respond_to do |format|
        format.html
        format.turbo_stream
      end
    end
  end
end
