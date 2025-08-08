import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["radius", "label"]

  connect() {
    this.update()
  }

  update() {
    const value = this.radiusTarget.value
    this.labelTarget.textContent = `Arrondi des éléments (${value}px)`
  }
}
