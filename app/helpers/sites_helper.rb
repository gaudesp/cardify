module SitesHelper
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
    CSS
  end

  private

  def hex_to_rgb(hex)
    hex = hex.delete("#")
    r, g, b = hex.scan(/../).map(&:hex)
    "#{r}, #{g}, #{b}"
  end
end
