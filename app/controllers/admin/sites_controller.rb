module Admin
  class SitesController < BaseController
    def edit; end

    def update
      if current_site.update(site_params)
        redirect_to admin_site_edit_path(current_site), notice: "Site successfully updated"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def site_params
      base = params.require(:site).permit(
        :company_name,
        :phone_number,
        :contact_email,
        :published,
        :aside_image,
        setting: {},
        social_links_attributes: [
          :id,
          :platform,
          :url,
          :_destroy
        ]
      )

      return base.merge(setting: default_theme) if params[:site][:reset_theme] == "1"

      theme = params[:site][:setting]&.permit(:radius, :color_primary, :color_secondary)&.to_h || {}
      return base if theme.empty?

      base.merge(setting: @site.setting.deep_merge("theme" => theme))
    end

    def default_theme
      {
        "theme" => {
          "radius" => "10px",
          "color_primary" => "#86d17c",
          "color_secondary" => "#50a2a1",
          "background_gradient" => "bottom right"
        }
      }
    end
  end
end
