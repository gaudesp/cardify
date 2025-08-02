module SitesHelper
  def site_status_badge(site)
    bg_color = site.published? ? "bg-green-500" : "bg-red-500"
    text_color = site.published? ? "text-green-600" : "text-red-600"
    label = site.published? ? "En ligne" : "Hors ligne"

    content_tag(:span, class: "inline-flex items-center gap-2 text-sm #{text_color}") do
      concat content_tag(:span, "", class: "inline-block w-3 h-3 rounded-full #{bg_color}")
      concat content_tag(:span, label)
    end
  end

  def site_theme_css_vars(site)
    theme = site.setting["theme"] || {}
    primary = theme["color_primary"] || "#86d17c"
    secondary = theme["color_secondary"] || "#50a2a1"
    background_gradient = theme["background_gradient"] || "bottom right"
    radius = theme["radius"] || "10px"

    primary_rgb = hex_to_rgb(primary)
    secondary_rgb = hex_to_rgb(secondary)

    <<~CSS.html_safe
      :root {
        --color-primary: #{primary};
        --color-primary-rgb: #{primary_rgb};
        --color-secondary: #{secondary};
        --color-secondary-rgb: #{secondary_rgb};
        --radius: #{radius};
      }

      .background.gradient {
        background: linear-gradient(to #{background_gradient}, var(--color-secondary) 0%, var(--color-primary) 100%);
      }
      @media (min-width: 1100px) {
        .wrapper {
          margin: 10px 0 10px 0!important;
        }
      }
    CSS
  end

  private

  def hex_to_rgb(hex)
    hex = hex.delete("#")
    r, g, b = hex.scan(/../).map(&:hex)
    "#{r}, #{g}, #{b}"
  end
end
