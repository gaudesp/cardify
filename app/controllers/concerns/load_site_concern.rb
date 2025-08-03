# frozen_string_literal: true

module LoadSiteConcern
  extend ActiveSupport::Concern

  included do
    before_action :set_site
    helper_method :current_site
  end

  private

  def set_site
    @site = Site.find_by!(slug: params[:site_slug])
  end

  def current_site
    @site
  end
end
