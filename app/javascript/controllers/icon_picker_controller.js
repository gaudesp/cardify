import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["custom", "preview", "button"]

  connect() {
    this.updateVisual(this.customTarget.value)
  }

  select(event) {
    const icon = event.currentTarget.dataset.iconValue
    this.customTarget.value = icon
    this.updateVisual(icon)
  }

  preview(event) {
    const icon = event.target.value
    this.updateVisual(icon)
  }

  updateVisual(icon) {
    this.previewTarget.className = `fa-solid fa-${icon} text-lg`

    this.buttonTargets.forEach((btn) => {
      const isActive = btn.dataset.iconValue === icon
      btn.classList.toggle("ring-2", isActive)
      btn.classList.toggle("ring-gray-800", isActive)
      btn.classList.toggle("border-gray-900", isActive)
    })
  }
}
