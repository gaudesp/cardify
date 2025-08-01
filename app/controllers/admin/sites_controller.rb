
class Admin::SitesController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action :set_site, only: %i[index edit update]

  def index; end

  def edit; end

  def update
    if @site.update(site_params)
      redirect_to admin_edit_site_path(@site), notice: "Site updated successfully"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_site
    @site = current_user.sites.find_by!(slug: params[:site_slug])
  end

  def site_params
    params.require(:site).permit(
      :company_name,
      :phone_number,
      :contact_email,
      :published,
      :aside_image,
      social_links_attributes: %i[id platform url _destroy]
    )
  end
end
