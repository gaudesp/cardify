module SitesHelper
  def site_theme_css_vars(site)
    theme = site.setting["theme"] || {}
    primary = theme["color_primary"] || "#86d17c"
    secondary = theme["color_secondary"] || "#50a2a1"
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
    CSS
  end

  private

  def hex_to_rgb(hex)
    hex = hex.delete("#")
    r, g, b = hex.scan(/../).map(&:hex)
    "#{r}, #{g}, #{b}"
  end
end
