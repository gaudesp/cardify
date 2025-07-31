// controllers/nav_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["item"]

  connect() {
    if (window.innerWidth >= 1100) this.updateActive()
    window.addEventListener("turbo:load", this.updateActiveBound = this.updateActive.bind(this))
  }

  disconnect() {
    window.removeEventListener("turbo:load", this.updateActiveBound)
  }

  updateActive() {
    const segments = window.location.pathname.split("/").filter(Boolean)
    const currentSlug = segments[1]
    let matched = false

    this.itemTargets.forEach(el => {
      const isActive = el.dataset.tab === currentSlug
      el.classList.toggle("active", isActive)
      if (isActive) matched = true
    })

    if (!matched && this.itemTargets.length > 0) {
      this.itemTargets[0].classList.add("active")
    }
  }
}
