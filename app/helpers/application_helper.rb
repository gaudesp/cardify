module ApplicationHelper
  def app_theme_css()
    <<~CSS.html_safe
      :root {
        --color-primary: #86d17c;
        --color-primary-rgb: 134, 209, 124;
        --color-secondary: #50a2a1;
        --color-secondary-rgb: 80, 162, 161;
        --radius: 10px;
      }
      .background.gradient {
        background: linear-gradient(to bottom right, var(--color-secondary) 0%, var(--color-primary) 100%);
      }
      @media (max-width: 1100px) {
        aside {
          margin-top: 80px!important;
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
    CSS
  end
end
