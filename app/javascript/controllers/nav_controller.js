// app/javascript/controllers/nav_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["item"]

  connect() {
    this.updateActive()
    window.addEventListener("turbo:load", this.updateActiveBound = this.updateActive.bind(this))
  }

  disconnect() {
    window.removeEventListener("turbo:load", this.updateActiveBound)
  }

  updateActive() {
    const segments = window.location.pathname.split("/").filter(Boolean)

    let currentTab = null
    let inShowcaseRoot = false

    if (segments[0] === "admin") {
      // Exemple : /admin/slug/pages → segments[2] = "pages"
      currentTab = segments[2] || "admin"
    } else if (segments.length === 0) {
      currentTab = "public"
    } else if (segments.length === 1) {
      inShowcaseRoot = true // ex: /naro-streetfood
      currentTab = null
    } else {
      currentTab = segments[1]
    }

    let matched = false

    this.itemTargets.forEach(el => {
      const isActive = el.dataset.tab === currentTab
      el.classList.toggle("active", isActive)
      if (isActive) matched = true
    })

    if (!matched && inShowcaseRoot && this.itemTargets.length > 0) {
      this.itemTargets[0].classList.add("active")
    }
  }
}
