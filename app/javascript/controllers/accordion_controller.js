import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["toggle", "panel", "icon"]
  static values = { key: String }

  connect() {
    this.openIndexes = []
    this.key = this.keyValue || "accordion"
    this.loadState()
    this.handleInitialState()
    this.setupFormTracking()
    this.setupInputTracking()
  }

  loadState() {
    const raw = sessionStorage.getItem(`${this.key}-open-indexes`)
    this.openIndexes = raw ? JSON.parse(raw) : []
  }

  saveState() {
    sessionStorage.setItem(`${this.key}-open-indexes`, JSON.stringify(this.openIndexes))
    sessionStorage.setItem(`${this.key}-path`, window.location.pathname)
  }

  handleInitialState() {
    const submitted = sessionStorage.getItem(`${this.key}-submitted`) === "1"
    const pathMatches = sessionStorage.getItem(`${this.key}-path`) === window.location.pathname
    let hasOpened = false
    const indexesToOpen = new Set()

    // 1. Ouvrir toutes les sections avec erreurs
    this.panelTargets.forEach((panel, index) => {
      const hasError = panel.querySelector(".field_with_errors, [aria-invalid='true']")
      if (hasError) {
        indexesToOpen.add(index)
        hasOpened = true
      }
    })

    // 2. Sinon, ouvrir celles en mémoire
    if (!hasOpened && submitted && pathMatches && this.openIndexes.length > 0) {
      this.openIndexes.forEach(index => indexesToOpen.add(index))
      hasOpened = true
    }

    // 3. Sinon, ouvrir la première section par défaut
    if (!hasOpened && this.panelTargets.length > 0) {
      indexesToOpen.add(0)
    }

    // Appliquer l’état d’ouverture
    requestAnimationFrame(() => {
      this.panelTargets.forEach((panel, index) => {
        if (indexesToOpen.has(index)) {
          panel.classList.add("is-open")
          this.expandPanel(panel, this.iconTargets[index])
        } else {
          panel.classList.remove("is-open")
          this.collapsePanel(panel, this.iconTargets[index])
        }
      })
    })

    sessionStorage.removeItem(`${this.key}-submitted`)
    sessionStorage.removeItem(`${this.key}-path`)
  }

  setupFormTracking() {
    const form = this.element.closest("form")
    if (!form) return

    form.addEventListener("submit", () => {
      sessionStorage.setItem(`${this.key}-submitted`, "1")
      sessionStorage.setItem(`${this.key}-path`, window.location.pathname)

      const open = []
      this.panelTargets.forEach((panel, index) => {
        if (panel.classList.contains("is-open")) open.push(index)
      })
      sessionStorage.setItem(`${this.key}-open-indexes`, JSON.stringify(open))
    }, { once: true })
  }

  setupInputTracking() {
    this.element.addEventListener("input", (event) => {
      const changedPanel = event.target.closest("[data-accordion-target='panel']")
      const index = this.panelTargets.indexOf(changedPanel)
      if (index !== -1 && !this.openIndexes.includes(index)) {
        this.openIndexes.push(index)
        this.saveState()
      }
    })
  }

  toggle(event) {
    const toggle = event.currentTarget
    const index = this.toggleTargets.indexOf(toggle)
    const panel = this.panelTargets[index]
    if (!panel) return

    const isOpen = panel.classList.contains("is-open")

    // Fermer tous les autres
    this.panelTargets.forEach((p, i) => {
      p.classList.remove("is-open")
      this.collapsePanel(p, this.iconTargets[i])
    })
    this.openIndexes = []

    // Ouvrir le bon s’il était fermé
    if (!isOpen) {
      panel.classList.add("is-open")
      this.expandPanel(panel, this.iconTargets[index])
      this.openIndexes = [index]
    }

    this.saveState()
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

  registerPanel(panel, icon) {
    const panels = this.panelTargets
    const index = panels.indexOf(panel)
    if (index === -1) {
      this.element.querySelectorAll('[data-accordion-target="panel"]').forEach(el => {
        if (!this.panelTargets.includes(el)) this.panelTargets.push(el)
      })
      this.element.querySelectorAll('[data-accordion-target="icon"]').forEach(el => {
        if (!this.iconTargets.includes(el)) this.iconTargets.push(el)
      })
    }

    panel.classList.add("is-open")
    this.expandPanel(panel, icon)
  }
}
