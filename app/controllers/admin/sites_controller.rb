class Admin::SitesController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action :set_site, only: %i[index edit update]

  def index; end

  def edit; end

  def update
    if @site.update(site_params)
      redirect_to admin_edit_site_path(@site), notice: "Site updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_site
    @site = current_user.sites.find_by!(slug: params[:site_slug])
  end

  def site_params
    base = params.require(:site).permit(
      :company_name,
      :phone_number,
      :contact_email,
      :published,
      :aside_image,
      setting: {},
      social_links_attributes: %i[id platform url _destroy]
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
