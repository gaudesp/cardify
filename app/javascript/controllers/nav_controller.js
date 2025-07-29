import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["item"]

  connect() {
    this.updateActive()
    window.addEventListener("turbo:load", this.updateActive.bind(this))
  }

  disconnect() {
    window.removeEventListener("turbo:load", this.updateActive.bind(this))
  }

  updateActive() {
    const segments = window.location.pathname.split("/").filter(Boolean)
    const currentSlug = segments[1]

    let matched = false

    this.itemTargets.forEach((el, index) => {
      const isActive = el.dataset.tab === currentSlug
      el.classList.toggle("active", isActive)

      if (isActive) matched = true
    })

    if (!matched && this.itemTargets.length > 0) {
      this.itemTargets[0].classList.add("active")
    }
  }
}
