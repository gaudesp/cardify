module Showcase
  class BaseController < ApplicationController
    layout "showcase"
    include LoadSiteConcern

    before_action :set_is_mobile

    protected

      def set_is_mobile
        @is_mobile = mobile_device?
      end
    
    private

      def mobile_device?
        request.user_agent =~ /Mobile|webOS/
      end
  end
end
