class CustomFormBuilder < ActionView::Helpers::FormBuilder
  DEFAULT_INPUT_CLASSES = "block w-full p-2 border rounded bg-white focus:outline-none"

  def switch_field(method, label: nil, label_text: nil, **options)
    id = "#{object_name}_#{method}"
    inner_label = label_text || method.to_s.humanize

    input = @template.content_tag(:label,
      for: id,
      class: "flex items-center justify-between w-full cursor-pointer px-4 py-2 bg-white hover:bg-blue-50 border rounded transition"
    ) do
      @template.content_tag(:span, inner_label, class: "text-sm text-gray-800") +
      check_box(method, { id: id, class: "hidden", **options }) +
      @template.content_tag(:span, "", class: "w-11 h-6 inline-block bg-gray-300 rounded-full relative transition-colors") do
        @template.content_tag(:span, "", class: "absolute left-0.5 top-0.5 w-5 h-5 bg-white rounded-full transition-transform", data: { switch_thumb: true })
      end
    end

    wrap_with_label(method, label, input)
  end

  def file_field(method, id: nil, label: nil, label_text: nil, **options)
    id ||= "#{object_name}_#{method}"
    label_text ||= method.to_s.humanize

    input = @template.content_tag(:div, data: { controller: "file-upload" }) do
      @template.label_tag(id,
        class: "w-full flex items-center justify-center p-2.5 border rounded text-sm font-medium text-gray-700 bg-white hover:bg-blue-50 cursor-pointer transition text-center text-wrap") do
        @template.content_tag(:span, class: "flex items-center gap-2 text-gray-600", id: "file-name") do
          @template.content_tag(:i, "", class: "fa-solid fa-upload") + " #{label_text}"
        end
      end +
      super(method, { class: "sr-only", id: id, direct_upload: true, data: { action: "change->file-upload#updateFileName" } }.merge(options))
    end

    wrap_with_label(method, label, input)
  end

  def text_field(method, options = {})
    label = options.delete(:label)
    input = super(method, merge_input_class(options))
    wrap_with_label(method, label, input)
  end

  def email_field(method, options = {})
    label = options.delete(:label)
    input = super(method, merge_input_class(options))
    wrap_with_label(method, label, input)
  end

  def telephone_field(method, options = {})
    label = options.delete(:label)
    input = super(method, merge_input_class(options))
    wrap_with_label(method, label, input)
  end

  def number_field(method, options = {})
    label = options.delete(:label)
    input = super(method, merge_input_class(options))
    wrap_with_label(method, label, input)
  end

  def panel_field(method, as: :text, **options)
    handlers = {
      onclick: "event.stopPropagation()",
      onfocus: "event.stopPropagation()",
      onmousedown: "event.stopPropagation()"
    }

    base = DEFAULT_INPUT_CLASSES
            .gsub(/\bborder\b/, "")
            .gsub(/\bbg-white\b/, "")
            .squeeze(" ")
            .strip

    forced = "font-bold bg-transparent border-transparent #{base}".squeeze(" ").strip
    options[:class] = [forced, options[:class]].compact.join(" ")

    opts = options.merge(handlers)

    case as
    when :text   then __core_field(:text_field, method, opts)
    when :email  then __core_field(:email_field, method, opts)
    when :tel    then __core_field(:telephone_field, method, opts)
    when :url    then __core_field(:url_field, method, opts)
    when :number then __core_field(:number_field, method, opts)
    else             __core_field(:text_field, method, opts)
    end
  end

  def checkbox_field(method, label: nil, **options)
    id = "#{object_name}_#{method}"
    label_text = label || method.to_s.humanize

    @template.content_tag(:label,
      for: id,
      class: "mt-4 flex items-center justify-between w-full cursor-pointer px-4 py-2.5 bg-white hover:bg-blue-50 border rounded transition"
    ) do
      @template.content_tag(:span, label_text, class: "text-sm text-gray-800") +
      check_box(method, { id: id, class: "h-5 w-5 text-blue-600 border-gray-300 rounded focus:ring-blue-500", **options })
    end
  end

  def range_field(method, options = {})
    label = options.delete(:label)
    label_options = options.delete(:label_options) || {}
    wrapper_options = options.delete(:wrapper) || {}

    options[:class] = [options[:class], "w-full"].compact.join(" ")
    input = super(method, options)

    wrap_with_label(method, label, input, label_options:, wrapper_options:)
  end

  def color_field(method, options = {})
    label = options.delete(:label)

    options[:class] = [options[:class], "block w-full h-11 border rounded bg-white focus:outline-none"].compact.join(" ")
    input = super(method, options)

    wrap_with_label(method, label, input)
  end

  def select(method, choices = nil, options = {}, html_options = {})
    label = options.delete(:label) || html_options.delete(:label)

    html_options = merge_input_class(html_options)
    html_options[:class] += " appearance-none pr-10 relative"

    select_tag = super(method, choices, options, html_options)

    wrapper = @template.content_tag(:div, class: "relative") do
      select_tag +
      @template.content_tag(:div, class: "pointer-events-none absolute inset-y-0 right-0 flex items-center px-3 text-gray-500") do
        @template.content_tag(:i, "", class: "fa-solid fa-chevron-down text-sm")
      end
    end

    wrap_with_label(method, label, wrapper)
  end


  def url_field(method, options = {})
    label = options.delete(:label)
    input = super(method, merge_input_class(options))
    wrap_with_label(method, label, input)
  end

  def icon_field(method, options = {})
    label = options.delete(:label)
    wrapper_options = options.delete(:wrapper) || {}
    icons = options.delete(:icons) || %w[]

    value = options[:value] || @object.public_send(method)

    buttons = if icons.any?
      @template.content_tag(:div, class: "flex flex-wrap gap-2 mb-2", data: { icon_picker_target: "buttons" }) do
        icons.map do |icon|
          @template.button_tag(
            type: "button",
            title: icon,
            class: "icon-button w-8 h-8 flex items-center justify-center border rounded text-gray-600 hover:bg-blue-50 transition-all bg-white",
            data: {
              action: "icon-picker#select",
              icon_picker_target: "button",
              icon_value: icon
            }
          ) do
            @template.content_tag(:i, "", class: "fa-solid fa-#{icon} text-sm")
          end
        end.join.html_safe
      end
    end

    preview = @template.content_tag(:span,
      @template.content_tag(:i, "", class: "fa-solid #{'fa-' + value if value}", data: { icon_picker_target: "preview" }),
      class: "absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-gray-500"
    )

    field = @template.content_tag(:div, class: "relative") do
      preview +
      text_field(method, {
        placeholder: "Icône",
        autocomplete: "off",
        value: value,
        class: "block w-full pl-10 pr-2 py-2 border rounded-md bg-white focus:outline-none"
      }.merge(options))
    end

    input = @template.content_tag(:div, class: "space-y-4", **wrapper_options) do
      @template.safe_join([buttons, field].compact)
    end

    wrap_with_label(method, label, input)
  end


  private

  def merge_input_class(options)
    default_class = DEFAULT_INPUT_CLASSES
    options[:class] = [options[:class], default_class].compact.join(" ")
    options
  end

  def wrap_with_label(method, label_text, input_html, label_options: {}, wrapper_options: {})
    return input_html unless label_text.present?

    @template.content_tag(:div, { class: "mb-2" }.merge(wrapper_options)) do
      @template.label(method, label_text, { class: "block text-sm font-medium text-gray-700 mb-2" }.merge(label_options)) +
      input_html
    end
  end

  def extract_nested_value(method)
    parts = method.to_s.split("_")
    return if parts.size < 2

    root_key = parts.shift
    return unless object.respond_to?(root_key)

    scope = object.public_send(root_key)
    parts.each do |key|
      break unless scope.is_a?(Hash)
      scope = scope[key]
    end

    scope
  end

  def select_icon
    @template.content_tag(:div, class: "pointer-events-none absolute inset-y-0 right-0 flex items-center px-2 text-gray-700") do
      @template.content_tag(:i, "", class: "fa-solid fa-chevron-down text-sm")
    end
  end

  def __core_field(helper_name, method, opts)
    ActionView::Helpers::FormBuilder.instance_method(helper_name).bind(self).call(method, opts)
  end
end
