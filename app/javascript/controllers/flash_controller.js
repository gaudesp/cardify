import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    setTimeout(() => this.close(), 8000)
  }

  close() {
    this.element.classList.remove("hover:translate-x-1")
    this.element.classList.add("flash--closing")
    setTimeout(() => this.element.remove(), 300)
  }
}
