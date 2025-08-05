module Admin
  class PagesController < BaseController
    include ActionView::RecordIdentifier
    before_action :set_page, only: %i[edit update destroy move_up move_down]

    def index
      @pages = current_site.pages.order(:position)
    end

    def new
      @page = current_site.pages.new
    end

    def create
      @page = current_site.pages.new(page_params)
      if @page.save
        redirect_to admin_site_pages_path(current_site), notice: "Page created"
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @page.update(page_params)
        redirect_to edit_admin_site_page_path(current_site), notice: "Page updated"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @page.destroy
      respond_with_updated_list("Page deleted")
    end

    def move_up
      @page.move_higher
      respond_with_updated_list("Position updated")
    end

    def move_down
      @page.move_lower
      respond_with_updated_list("Position updated")
    end

    private

    def set_page
      @page = current_site.pages.find_by!(slug: params[:id])
    end

    def page_params
      params.require(:page).permit(
        :title,
        :label,
        :icon,
        cards_attributes: [
          :id,
          :type,
          :_destroy,
          :content,
          card_menu_categories_attributes: [
            :id,
            :title,
            :_destroy,
            card_menu_items_attributes: [
              :id,
              :title,
              :description,
              :price,
              :_destroy
            ]
          ]
        ]
      )
    end

    def respond_with_updated_list(notice_message)
      @pages = current_site.pages.order(:position)

      respond_to do |format|
        format.turbo_stream do
          flash.now[:notice] = notice_message
          render turbo_stream: [
            turbo_stream.replace("pages_list", partial: "admin/pages/list", locals: { pages: @pages }),
            turbo_stream.update("flash", partial: "shared/flash")
          ]
        end
      end
    end
  end
end
