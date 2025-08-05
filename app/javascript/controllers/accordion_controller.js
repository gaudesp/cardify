import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel", "icon"]

  connect() {
    const form = this.element.tagName === "FORM" ? this.element : this.element.querySelector("form")
    if (form) {
      form.addEventListener("submit", () => {
        sessionStorage.setItem("accordion-submitted", "1")
        sessionStorage.setItem("accordion-path", window.location.pathname)

        this.panelTargets.forEach((panel, index) => {
          const isOpen = panel.classList.contains("is-open")
          if (isOpen) sessionStorage.setItem("accordion-open-index", index)
        })
      }, { once: true })
    }

    const submitted = sessionStorage.getItem("accordion-submitted") === "1"
    const pathMatches = sessionStorage.getItem("accordion-path") === window.location.pathname
    const persistedIndex = sessionStorage.getItem("accordion-open-index")

    // Appliquer is-open avant le repaint
    let opened = false

    this.panelTargets.forEach((panel, index) => {
      const hasError = panel.querySelector(".field_with_errors, [aria-invalid='true']")
      if (hasError && !opened) {
        panel.classList.add("is-open")
        opened = true
      }
    })

    if (!opened && submitted && pathMatches && persistedIndex !== null) {
      this.panelTargets[parseInt(persistedIndex, 10)].classList.add("is-open")
      opened = true
    }

    if (!opened && this.panelTargets.length > 0) {
      this.panelTargets[0].classList.add("is-open")
    }

    requestAnimationFrame(() => {
      this.panelTargets.forEach((panel, index) => {
        if (panel.classList.contains("is-open")) {
          this.expandPanel(panel, this.iconTargets[index])
        } else {
          this.collapsePanel(panel, this.iconTargets[index])
        }
      })
    })

    sessionStorage.removeItem("accordion-submitted")
    sessionStorage.removeItem("accordion-path")
  }

  toggle(event) {
    const index = parseInt(event.currentTarget.dataset.index, 10)
    const panel = this.panelTargets[index]

    const isOpen = panel.classList.contains("is-open")

    this.panelTargets.forEach((p, i) => {
      p.classList.remove("is-open")
      this.collapsePanel(p, this.iconTargets[i])
    })

    if (!isOpen) {
      panel.classList.add("is-open")
      this.expandPanel(panel, this.iconTargets[index])
      sessionStorage.setItem("accordion-open-index", index)
    } else {
      sessionStorage.removeItem("accordion-open-index")
    }
  }

  expandPanel(panel, icon) {
    panel.style.maxHeight = `${panel.scrollHeight}px`
    if (icon) icon.style.transform = "rotate(180deg)"
  }

  collapsePanel(panel, icon) {
    panel.style.maxHeight = "0px"
    if (icon) icon.style.transform = "rotate(0deg)"
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
}
