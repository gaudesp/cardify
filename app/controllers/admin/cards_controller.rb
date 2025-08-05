module Admin
  class CardsController < BaseController
    def fields
      type = params[:type]
      return head :bad_request unless %w[CardContent CardMenu].include?(type)

      card = type.constantize.new
      f = view_context.nested_form_builder_for(
        card, "cards", "NEW_RECORD",
        parent_builder: ActionView::Helpers::FormBuilder.new("page", Page.new, view_context, {})
      )

      html = render_to_string partial: "admin/cards/#{type.underscore}/fields", locals: { f: f }
      render plain: html
    end
  end
end
