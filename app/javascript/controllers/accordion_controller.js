import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["toggle", "panel", "icon"]
  static values = { mode: String, key: String }
  openIndexes = new Set()
  dirty = new Set()
  dirtyNames = new Set()

  connect() {
    this.key = this.keyValue || "accordion"
    this.loadState()
    this.observeInputs()
    this.initObservers()
    this.handleInitialState()
    this.element.addEventListener("nested:added", e => this.onNestedAdded(e.detail.item))
    this.element.addEventListener("nested:added-root", e => this.onNestedAddedRoot(e.detail.item))
    this.element.addEventListener("nested:removed", () => this.refreshAllOpen())
    this._onSubmitEnd = e => this.onSubmitEnd(e)
    document.addEventListener("turbo:submit-end", this._onSubmitEnd)
    if (this.element.querySelector(".field_with_errors, [aria-invalid='true']")) {
      requestAnimationFrame(() => this.openInvalidAndDirtyPanelsRecursively())
    }
  }

  disconnect() {
    this.resizeObservers?.forEach(o => o.disconnect())
    this.mutationObservers?.forEach(o => o.disconnect())
    document.removeEventListener("turbo:submit-end", this._onSubmitEnd)
  }

  toggle(e) {
    const i = this.toggleTargets.indexOf(e.currentTarget)
    if (i < 0) return
    const prev = new Set(this.openIndexes)
    if (this.modeValue === "one") this.openIndexes = new Set(this.openIndexes.has(i) ? [] : [i])
    else this.openIndexes.has(i) ? this.openIndexes.delete(i) : this.openIndexes.add(i)
    this.applyOpenState()
    prev.forEach(pi => { if (!this.openIndexes.has(pi)) this.closeDescendants(this.panelTargets[pi]) })
    this.openIndexes.forEach(ni => this.resetDescendantsToDefault(this.panelTargets[ni]))
    this.refreshAllOpen()
    this.saveState()
  }

  handleInitialState() {
    const submitted = sessionStorage.getItem(`${this.key}-submitted`) === "1"
    const pathOk = sessionStorage.getItem(`${this.key}-path`) === window.location.pathname
    const err = new Set()
    this.panelTargets.forEach((p, i) => {
      if (p.querySelector(".field_with_errors, [aria-invalid='true']")) err.add(i)
    })
    if (err.size > 0) {
      this.openIndexes = err
      err.forEach(i => this.openAncestorsFor(this.panelTargets[i]))
    } else if (submitted && pathOk && this.openIndexes.size > 0) {
      this.openIndexes = new Set(this.openIndexes)
    } else if (this.modeValue === "all") {
      this.openIndexes = new Set(this.panelTargets.map((_, i) => i))
    } else {
      this.openIndexes = new Set([0].filter(i => i < this.panelTargets.length))
    }
    this.applyOpenState()
    if (err.size > 0) {
      this.openIndexes.forEach(i => this.openDescendantsWithSignals(this.panelTargets[i]))
    } else {
      this.panelTargets.forEach((p, i) => {
        if (this.openIndexes.has(i)) this.resetDescendantsToDefault(p)
        else this.closeDescendants(p)
      })
    }
    this.refreshAllOpen()
    sessionStorage.removeItem(`${this.key}-submitted`)
    sessionStorage.removeItem(`${this.key}-path`)
  }

  applyOpenState() {
    this.panelTargets.forEach((panel, i) => {
      const open = this.openIndexes.has(i)
      panel.parentElement.classList.toggle("is-open", open)
      const t = this.toggleTargets[i]
      if (t) t.setAttribute("aria-expanded", open)
      panel.style.maxHeight = open ? `${panel.scrollHeight}px` : "0px"
      const ic = this.iconTargets[i]
      if (ic) ic.style.transform = open ? "rotate(180deg)" : "rotate(0deg)"
    })
  }

  observeInputs() {
    const markDirty = el => {
      this.dirty.add(el)
      if (el.name) {
        this.dirtyNames.add(el.name)
        sessionStorage.setItem(`${this.key}-dirty-names`, JSON.stringify([...this.dirtyNames]))
      }
    }
    this.element.querySelectorAll("input, textarea, select").forEach(el => {
      el.addEventListener("input", () => markDirty(el))
      el.addEventListener("change", () => markDirty(el))
    })
    const stored = sessionStorage.getItem(`${this.key}-dirty-names`)
    if (stored) {
      try { this.dirtyNames = new Set(JSON.parse(stored)) } catch { this.dirtyNames = new Set() }
    }

    const form = this.element.closest("form")
    if (!form) return
    form.addEventListener("submit", () => {
      sessionStorage.setItem(`${this.key}-submitted`, "1")
      sessionStorage.setItem(`${this.key}-path`, window.location.pathname)
      sessionStorage.setItem(this.key, JSON.stringify([...this.openIndexes]))
      sessionStorage.setItem(`${this.key}-dirty-names`, JSON.stringify([...this.dirtyNames]))
    }, { once: true })
  }

  initObservers() {
    this.resizeObservers = this.panelTargets.map((panel, i) => {
      const ro = new ResizeObserver(() => { if (this.openIndexes.has(i)) panel.style.maxHeight = `${panel.scrollHeight}px` })
      ro.observe(panel)
      return ro
    })
    this.mutationObservers = this.panelTargets.map((panel, i) => {
      const mo = new MutationObserver(() => { if (this.openIndexes.has(i)) panel.style.maxHeight = `${panel.scrollHeight}px` })
      mo.observe(panel, { childList: true, subtree: true })
      return mo
    })
  }

  onSubmitEnd(e) {
    if (!e?.detail || e.detail.success === false) {
      const stored = sessionStorage.getItem(`${this.key}-dirty-names`)
      if (stored) {
        try { this.dirtyNames = new Set(JSON.parse(stored)) } catch { this.dirtyNames = new Set() }
      }
      this.openInvalidAndDirtyPanelsRecursively()
      sessionStorage.removeItem(`${this.key}-dirty-names`)
    }
  }

  openInvalidAndDirtyPanelsRecursively() {
    const hasErr = el => el.closest(".field_with_errors") || el.getAttribute("aria-invalid") === "true"
    const isDirtyByName = el => el.name && this.dirtyNames.has(el.name)

    this.closeDescendants(this.element)
    this.openIndexes.clear()
    this.applyOpenState()

    const toOpen = new Set()
    this.panelTargets.forEach((panel, i) => {
      const inputs = panel.querySelectorAll("input, textarea, select")
      if ([...inputs].some(el => hasErr(el) || this.dirty.has(el) || isDirtyByName(el))) {
        toOpen.add(i)
      }
    })

    this.openIndexes = toOpen
    this.applyOpenState()

    this.openIndexes.forEach(i => this.openAncestorsFor(this.panelTargets[i]))

    this.panelTargets.forEach((panel, i) => {
      if (this.openIndexes.has(i)) this.openDescendantsWithSignals(panel)
      else this.closeDescendants(panel)
    })

    this.refreshAllOpen()
    this.saveState()
  }

  getDescendantAccordions(root) {
    return [...root.querySelectorAll("[data-controller~='accordion']")]
      .map(el => this.application.getControllerForElementAndIdentifier(el, "accordion"))
      .filter(Boolean)
  }

  resetDescendantsToDefault(root) {
    this.getDescendantAccordions(root).forEach(c => {
      if (c.modeValue === "all") c.openIndexes = new Set(c.panelTargets.map((_, i) => i))
      else c.openIndexes = new Set([0].filter(i => i < c.panelTargets.length))
      c.applyOpenState(); c.refreshAllOpen(); c.saveState()
    })
  }

  closeDescendants(root) {
    this.getDescendantAccordions(root).forEach(c => {
      c.openIndexes.clear()
      c.applyOpenState(); c.refreshAllOpen(); c.saveState()
    })
  }

  openDescendantsWithSignals(root) {
    const hasErr = el => el.closest(".field_with_errors") || el.getAttribute("aria-invalid") === "true"
    const isDirtyByName = (c, el) => el.name && (c.dirty?.has?.(el) || c.dirtyNames?.has?.(el.name))
    this.getDescendantAccordions(root).forEach(c => {
      const stored = sessionStorage.getItem(`${c.key}-dirty-names`)
      if (stored) {
        try { c.dirtyNames = new Set(JSON.parse(stored)) } catch { c.dirtyNames = new Set() }
      }
      const toOpen = new Set()
      c.panelTargets.forEach((panel, i) => {
        const inputs = panel.querySelectorAll("input, textarea, select")
        if ([...inputs].some(el => hasErr(el) || isDirtyByName(c, el))) toOpen.add(i)
      })
      c.openIndexes = toOpen
      c.applyOpenState(); c.refreshAllOpen(); c.saveState()
    })
  }

  refreshAllOpen() {
    this.openIndexes.forEach(i => {
      const p = this.panelTargets[i]
      if (!p) return
      p.style.maxHeight = "none"
      const h = p.scrollHeight
      p.style.maxHeight = `${h}px`
    })
    let n = this.element.parentElement
    while (n) {
      const acc = n.closest("[data-controller~='accordion']")
      if (!acc) break
      const c = this.application.getControllerForElementAndIdentifier(acc, "accordion")
      if (!c) break
      c.openIndexes.forEach(i => {
        const p = c.panelTargets[i]
        if (!p) return
        p.style.maxHeight = "none"
        const h = p.scrollHeight
        p.style.maxHeight = `${h}px`
      })
      n = acc.parentElement
    }
  }

  onNestedAdded(el) {
    const target = (el && el.panel) || el
    this._openNewItem(target, 0)
  }

  openPanelContaining(el) {
    const idx = this._findPanelIndexFor(el)
    if (idx < 0) return
    const prev = new Set(this.openIndexes)
    this.openIndexes = this.modeValue === "one" ? new Set([idx]) : new Set([...this.openIndexes, idx])
    this.applyOpenState()
    prev.forEach(pi => { if (!this.openIndexes.has(pi) && this.panelTargets[pi]) this.closeDescendants(this.panelTargets[pi]) })
    if (this.panelTargets[idx]) this.resetDescendantsToDefault(this.panelTargets[idx])
  }

  openAncestorsFor(el) {
    let node = el
    while (node) {
      const acc = node.closest("[data-controller~='accordion']")
      if (!acc || acc === this.element) break
      const c = this.application.getControllerForElementAndIdentifier(acc, "accordion")
      if (!c) break
      const i = c._findPanelIndexFor(node)
      if (i >= 0) {
        c.openIndexes = new Set([...c.openIndexes, i])
        c.applyOpenState(); c.refreshAllOpen()
        node = c.panelTargets[i]
      } else {
        node = acc.parentElement
      }
    }
  }

  _openNewItem(el, tries = 0) {
    const idx = this._findPanelIndexFor(el)
    if (idx >= 0) {
      const prev = new Set(this.openIndexes)
      this.openIndexes = this.modeValue === "one" ? new Set([idx]) : new Set([...this.openIndexes, idx])
      this.applyOpenState()
      prev.forEach(pi => { if (!this.openIndexes.has(pi) && this.panelTargets[pi]) this.closeDescendants(this.panelTargets[pi]) })
      if (this.panelTargets[idx]) this.resetDescendantsToDefault(this.panelTargets[idx])
      this.openAncestorsFor(this.panelTargets[idx] || el)
      this.refreshAllOpen()
      this.saveState()
      return
    }
    if (tries < 12) requestAnimationFrame(() => this._openNewItem(el, tries + 1))
  }

  _findPanelIndexFor(el) {
    if (!el) return -1
    if (el.matches?.("[data-accordion-target='panel']")) {
      const i = this.panelTargets.indexOf(el); if (i >= 0) return i
    }
    const childPanel = el.querySelector?.("[data-accordion-target='panel']")
    if (childPanel) { const i = this.panelTargets.indexOf(childPanel); if (i >= 0) return i }
    const ancestorPanel = (el.closest && this.element.contains(el)) ? el.closest("[data-accordion-target='panel']") : null
    if (ancestorPanel) { const i = this.panelTargets.indexOf(ancestorPanel); if (i >= 0) return i }
    const item = el.closest?.("[data-nested-form-target='item']")
    if (item) { const i = this.panelTargets.findIndex(p => p.closest("[data-nested-form-target='item']") === item); if (i >= 0) return i }
    const i1 = this.panelTargets.findIndex(p => p?.contains(el)); if (i1 >= 0) return i1
    const i2 = this.panelTargets.findIndex(p => el?.contains?.(p)); if (i2 >= 0) return i2
    return -1
  }

  onNestedAddedRoot() {
    requestAnimationFrame(() => {
      const localPanels = this.panelTargets.filter(p => p.closest("[data-controller~='accordion']") === this.element)
      if (localPanels.length === 0) return
      const lastPanel = localPanels[localPanels.length - 1]
      const idx = this.panelTargets.indexOf(lastPanel)
      if (idx < 0) return
      const prev = new Set(this.openIndexes)
      this.openIndexes = this.modeValue === "one" ? new Set([idx]) : new Set([...this.openIndexes, idx])
      this.applyOpenState()
      prev.forEach(pi => { if (!this.openIndexes.has(pi) && this.panelTargets[pi]) this.closeDescendants(this.panelTargets[pi]) })
      if (this.panelTargets[idx]) this.resetDescendantsToDefault(this.panelTargets[idx])
      this.openAncestorsFor(this.panelTargets[idx])
      this.refreshAllOpen()
      this.saveState()
    })
  }

  saveState() {
    sessionStorage.setItem(this.key, JSON.stringify([...this.openIndexes]))
  }

  loadState() {
    const s = sessionStorage.getItem(this.key)
    if (s) this.openIndexes = new Set(JSON.parse(s))
  }
}
