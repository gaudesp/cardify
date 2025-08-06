import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["list", "item", "template", "typeSelect"]
  static values = {
    association: String,
    defaultType: String,
    excludeScroll: Boolean
  }

  add(event) {
    event.preventDefault()

    const type = event.currentTarget.dataset.type
    const template = type
      ? this.templateTargets.find(t => t.dataset.type === type)
      : this.templateTargets[0]

    if (!template) {
      console.warn("No matching template found")
      return
    }

    const content = template.innerHTML.replace(/NEW_RECORD/g, new Date().getTime())
    this.listTarget.insertAdjacentHTML("beforeend", content)

    requestAnimationFrame(() => {
      const items = this.listTarget.querySelectorAll("[data-nested-form-target='item']")
      const lastItem = items[items.length - 1]

      if (lastItem && !this.excludeScrollValue) {
        lastItem.scrollIntoView({ behavior: "smooth", block: "start" })
      }

      const accordion = this.element.closest("[data-controller~='accordion']")
      if (!accordion) return

      const controller = this.application.getControllerForElementAndIdentifier(accordion, "accordion")
      if (!controller) return

      const panel = lastItem.querySelector("[data-accordion-target='panel']")
      const icon = lastItem.querySelector("[data-accordion-target='icon']")

      if (panel && icon) {
        controller.registerPanel(panel, icon)
      } else {
        const currentPanel = this.element.closest("[data-accordion-target='panel']")
        if (currentPanel) {
          const index = controller.panelTargets.indexOf(currentPanel)
          if (index !== -1) controller.refreshHeight(index)
        }
      }
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
      controller?.applyInitialHeights?.()
    })
  }

  resolveTemplate() {
    const allTemplates = this.templateTargets
    if (allTemplates.length > 1) {
      const type = this.lastSelectedType() || this.defaultTypeValue || null
      return allTemplates.find(t => t.dataset.type === type)
    }
    return allTemplates[0]
  }

  lastSelectedType() {
    const selects = this.typeSelectTargets
    if (selects.length === 0) return null
    return selects[selects.length - 1]?.value
  }
}
