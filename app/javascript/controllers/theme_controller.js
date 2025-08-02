import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["radius", "label"]

  update() {
    const value = this.radiusTarget.value
    this.labelTarget.innerText = `Arrondi des éléments (${value}px)`
  }
}
