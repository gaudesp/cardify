import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel", "icon"]

  connect() {
    this.closeAll()

    let opened = false

    this.panelTargets.forEach((panel, index) => {
      const hasError = panel.querySelector(".field_with_errors, [aria-invalid='true']")
      if (hasError) {
        this.open(index)
        opened = true
      }
    })

    const wasSubmitted = sessionStorage.getItem("accordion-opened-after-submit") === "1"
    if (!opened && wasSubmitted) {
      const persistedIndex = sessionStorage.getItem("accordion-open-index")
      if (persistedIndex !== null) this.open(parseInt(persistedIndex, 10))
      sessionStorage.removeItem("accordion-opened-after-submit")
    }
  }

  toggle(event) {
    const index = parseInt(event.currentTarget.dataset.index, 10)
    const panel = this.panelTargets[index]
    const isOpen = panel.style.maxHeight && panel.style.maxHeight !== "0px"

    this.closeAll()

    if (!isOpen) {
      this.open(index)
      sessionStorage.setItem("accordion-open-index", index)
    } else {
      sessionStorage.removeItem("accordion-open-index")
    }
  }

  open(index) {
    const panel = this.panelTargets[index]
    const icon = this.iconTargets[index]

    requestAnimationFrame(() => {
      requestAnimationFrame(() => {
        panel.style.maxHeight = `${panel.scrollHeight}px`
        icon.style.transform = "rotate(180deg)"
      })
    })
  }

  refreshHeight(index) {
    const panel = this.panelTargets[index]
    if (!panel) return

    requestAnimationFrame(() => {
      panel.style.maxHeight = "none"
      const height = panel.scrollHeight
      panel.style.maxHeight = `${height}px`
    })
  }

  closeAll() {
    this.panelTargets.forEach(panel => (panel.style.maxHeight = "0px"))
    this.iconTargets.forEach(icon => (icon.style.transform = "rotate(0deg)"))
  }
}
