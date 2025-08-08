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
        setting: [:reset, { theme: [:radius, :color_primary, :color_secondary] }],
        social_links_attributes: [
          :id,
          :platform,
          :url,
          :_destroy
        ]
      )

      theme = base.dig(:setting, :theme) || {}

      return base.merge(setting: { "theme" => default_theme }) if base.dig(:setting, :reset) == "1"

      base[:setting] = @site.setting.deep_merge("theme" => default_theme.merge(theme.stringify_keys))
      base
    end

    def default_theme
      {
        "radius" => "10px",
        "color_primary" => "#86d17c",
        "color_secondary" => "#50a2a1",
        "background_gradient" => "bottom right"
      }
    end
  end
end
