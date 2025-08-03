import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["list", "item", "template"]
  static values = { association: String }

  add(event) {
    event.preventDefault()

    const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, new Date().getTime())
    this.listTarget.insertAdjacentHTML("beforeend", content)

    requestAnimationFrame(() => {
      const items = this.listTarget.querySelectorAll("[data-nested-form-target='item']")
      const lastItem = items[items.length - 1]
      if (lastItem) lastItem.scrollIntoView({ behavior: "smooth", block: "start" })

      const accordion = this.element.closest("[data-controller~='accordion']")
      if (!accordion) return

      const controller = this.application.getControllerForElementAndIdentifier(accordion, "accordion")
      controller?.refreshHeight(2)
    })
  }

  remove(event) {
    event.preventDefault()

    const item = event.target.closest("[data-nested-form-target='item']")
    const destroyInput = item.querySelector("input[name*='[_destroy]']")

    if (destroyInput) {
      destroyInput.value = "1"
      item.style.display = "none"
    } else {
      item.remove()
    }

    requestAnimationFrame(() => {
      const accordion = this.element.closest("[data-controller~='accordion']")
      if (!accordion) return

      const controller = this.application.getControllerForElementAndIdentifier(accordion, "accordion")
      controller?.refreshHeight(2)
    })
  }
}
