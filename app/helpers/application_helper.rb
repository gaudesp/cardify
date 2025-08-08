module ApplicationHelper
  def form_builder_for(object)
    ActionView::Helpers::FormBuilder.new(object.model_name.param_key, object, self, {})
  end

  def nested_form_builder_for(object, association, index, parent_builder: nil)
    object_name =
      if parent_builder
        "#{parent_builder.object_name}[#{association}_attributes][#{index}]"
      else
        "#{object.model_name.param_key}[#{association}_attributes][#{index}]"
      end

    template = parent_builder&.instance_variable_get(:@template) || self
    template = controller.view_context if template == self && defined?(controller)

    options = parent_builder&.instance_variable_get(:@options) || {}

    builder_class = parent_builder&.class || ActionView::Helpers::FormBuilder

    builder_class.new(
      object_name,
      object,
      template,
      options
    )
  end

  def app_theme_css()
    <<~CSS.html_safe
      :root {
        --color-primary: #86d17c;
        --color-primary-rgb: 134, 209, 124;
        --color-secondary: #50a2a1;
        --color-secondary-rgb: 80, 162, 161;
        --radius: 10px;
      }
      [data-accordion-target="panel"] {
        overflow: hidden;
        max-height: 0;
        transition: max-height 0.3s ease;
      }

      [data-accordion-target="panel"].is-open {
        max-height: 9999px;
        overflow: visible;
      }
      .visit {
        display: flex;
        padding: 1rem 1rem 0 0;
        height: 71px;
        font-size: 2rem;
        text-decoration: none;
        transition: color 0.2s ease;
        z-index: 50;
      }
      @media (min-width: 1100px) {
        .visit {
          position: sticky;
          top: 0;
          right: 0;
          float: right;
        }
      }
      @media (max-width: 1099px) {
        .visit {
          position: fixed;
          top: 0;
          right: 0;
        }
      }
      .visit:hover {
        color: var(--color-primary);
      }
      .background.gradient {
        background: linear-gradient(to bottom right, var(--color-secondary) 0%, var(--color-primary) 100%);
      }
      .aside-btn.active {
        color: var(--color-primary)!important;
      }
      @media (max-width: 1100px) {
        aside {
          margin-top: 100px!important;
          border-radius: var(--radius) var(--radius) 0 0!important;
        }
      }
      @media (max-width: 655px) { 
        .background.gradient {
          background: var(--color-white);
        }
        aside {
          margin-top: 64px!important;
          border-radius: 0!important;
        }
      }
      .border {
        border-color: var(--color-border);
      }
      .border-l {
        border-color: var(--color-border)!important;
      }
      .border-b {
        border-color: var(--color-border);
      }
      .btn-wrapper {
        position: static;
        height: 63px;
        padding: 0.75rem 0 0.75rem 0;
        border-top: 1px solid var(--color-border);
        background-color: white;
      }
      @media (max-width: 1099px) {
        .container {
          margin-bottom: 5rem;
        }
        .btn-wrapper {
          position: fixed;
          bottom: 0;
          left: 0;
          width: 100%;
          z-index: 50;
          display: flex;
          justify-content: center;
        }
        .btn-wrapper input {
          width: auto;
        }
        .btn-wrapper input {
          width: 50%;
        }
      }
      @media (max-width: 655px) {
        .btn-wrapper {
          padding: 1rem;
        }
        .btn-wrapper input {
          width: 100%;
        }
      }
      @media (min-width: 1100px) {
        .btn-wrapper {
          position: sticky;
          bottom: 0;
          display: flex;
          justify-content: flex-end;
        }
      }
    CSS
  end
end
