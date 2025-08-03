// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

import "trix"
import "@rails/actiontext"

document.addEventListener("turbo:submit-end", () => {
  sessionStorage.setItem("accordion-opened-after-submit", "1")
})
