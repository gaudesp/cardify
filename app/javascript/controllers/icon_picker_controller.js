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
    const validIcon = icon?.trim() || "question"
    this.previewTarget.className = `fa-solid fa-${validIcon} text-lg`

    this.buttonTargets.forEach((btn) => {
      const isActive = btn.dataset.iconValue === validIcon
    })
  }
}
