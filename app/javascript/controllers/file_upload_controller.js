import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  updateFileName(event) {
    const input = event.target
    const fileName = input.files[0]?.name
    const label = this.element.querySelector("#file-name")
    if (fileName && label) {
      label.textContent = fileName
    }
  }
}
