import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["list", "item", "template", "typeSelect"]
  static values = { association: String, defaultType: String, excludeScroll: Boolean }

  connect() {
    this._onSubmitEnd = e => {
      if (e.detail && e.detail.success) this.clearMarkedRemovals()
      else this.restoreMarkedRemovals()
    }
    document.addEventListener("turbo:submit-end", this._onSubmitEnd)
    this.initNextIndex()
    this.restoreMarkedRemovals()
  }

  disconnect() {
    document.removeEventListener("turbo:submit-end", this._onSubmitEnd)
  }

  associationName() {
    return this.associationValue || "nested"
  }

  indexRegex() {
    const assoc = this.escapeRegex(`${this.associationName()}_attributes`)
    return new RegExp(`\\[${assoc}\\]\\[(\\d+)\\]`)
  }

  newRecordRegex() {
    const assoc = this.escapeRegex(`${this.associationName()}_attributes`)
    return new RegExp(`(\\[${assoc}\\])\\[(NEW_RECORD)\\]`, "g")
  }

  escapeRegex(str) {
    return str.replace(/[.*+?^${}()|[\]\\]/g, "\\$&")
  }

  initNextIndex() {
    let maxIndex = -1
    const r = this.indexRegex()
    this.listTarget.querySelectorAll("input[name], textarea[name], select[name]").forEach(el => {
      const m = el.name.match(r)
      if (m && m[1] != null) {
        const n = parseInt(m[1], 10)
        if (!Number.isNaN(n) && n > maxIndex) maxIndex = n
      }
    })
    this.listTarget.dataset.nextIndex = String(maxIndex + 1)
  }

  nextIndex() {
    const cur = parseInt(this.listTarget.dataset.nextIndex || "0", 10)
    this.listTarget.dataset.nextIndex = String(cur + 1)
    return cur
  }

  targetedReplace(html, index) {
    return html.replace(this.newRecordRegex(), (_match, assocPart) => {
      return `${assocPart}[${index}]`
    })
  }

  add(e) {
    e.preventDefault()
    const t = this.resolveTemplate(e.currentTarget.dataset.type)
    if (!t) return
    const index = this.nextIndex()
    const html = this.targetedReplace(t.innerHTML, index)
    this.listTarget.insertAdjacentHTML("beforeend", html)
    this.afterAdd("nested:added")
  }

  addRoot(e) {
    e.preventDefault()
    const t = this.resolveTemplate(e.currentTarget.dataset.type)
    if (!t) return
    const index = this.nextIndex()
    const html = this.targetedReplace(t.innerHTML, index)
    this.listTarget.insertAdjacentHTML("beforeend", html)
    this.afterAdd("nested:added-root")
  }

  afterAdd(eventName) {
    requestAnimationFrame(() => {
      const last = this.listTarget.querySelector("[data-nested-form-target='item']:last-child")
      if (!last) return
      const panel = last.querySelector("[data-accordion-target='panel']") || null
      last.dispatchEvent(new CustomEvent(eventName, { detail: { item: last, panel }, bubbles: true }))

      if (!this.excludeScrollValue) {
        requestAnimationFrame(() => last.scrollIntoView({ behavior: "smooth", block: "start" }))
      }
      const input = last.querySelector("input, textarea, select")
      if (input) input.focus()
    })
  }

  remove(e) {
    e.preventDefault()
    const item = e.currentTarget.closest("[data-nested-form-target='item']")
    if (!item) return
    const msg = e.currentTarget.dataset.confirm || "Confirmer la suppression ?"
    if (!confirm(msg)) return

    const destroy = item.querySelector("input[name*='[_destroy]']")
    const idInput = item.querySelector("input[name$='[id]']")
    const persistedId = item.dataset.id || (idInput && idInput.value) || null
    const persisted = !!persistedId

    if (persisted && destroy) {
      destroy.value = "1"
      this.markRemoved(persistedId)
      item.querySelectorAll("input, textarea, select, button").forEach(el => {
        const n = el.getAttribute("name") || ""
        if (/\[_destroy\]$/.test(n) || /\[id\]$/.test(n)) return
        el.disabled = true
      })
      item.setAttribute("data-removed", "true")
      item.style.display = "none"
    } else if (persisted && !destroy) {
      this.markRemoved(persistedId)
      item.remove()
    } else {
      item.remove()
    }

    this.element.dispatchEvent(new CustomEvent("nested:removed", { bubbles: true }))
  }

  resolveTemplate(type) {
    if (type) return this.templateTargets.find(t => t.dataset.type === type)
    if (this.templateTargets.length > 1) {
      const v = this.lastSelectedType() || this.defaultTypeValue || null
      return this.templateTargets.find(t => t.dataset.type === v)
    }
    return this.templateTargets[0]
  }

  lastSelectedType() {
    const s = this.typeSelectTargets
    if (s.length === 0) return null
    return s[s.length - 1]?.value
  }

  get storageKey() {
    const scope = this.associationValue || "nested"
    return `${window.location.pathname}::removed::${scope}`
  }

  readMarkedRemovals() {
    try {
      const raw = sessionStorage.getItem(this.storageKey)
      const arr = raw ? JSON.parse(raw) : []
      return new Set(arr)
    } catch(_) {
      return new Set()
    }
  }

  writeMarkedRemovals(set) {
    sessionStorage.setItem(this.storageKey, JSON.stringify(Array.from(set)))
  }

  markRemoved(id) {
    if (!id) return
    const s = this.readMarkedRemovals()
    s.add(String(id))
    this.writeMarkedRemovals(s)
  }

  clearMarkedRemovals() {
    sessionStorage.removeItem(this.storageKey)
  }

  restoreMarkedRemovals() {
    const removed = this.readMarkedRemovals()
    if (removed.size === 0) return

    this.itemTargets.forEach(item => {
      const idInput = item.querySelector("input[name$='[id]']")
      const persistedId = item.dataset.id || (idInput && idInput.value)
      if (!persistedId) return
      if (!removed.has(String(persistedId))) return

      const destroy = item.querySelector("input[name*='[_destroy]']")
      if (destroy) destroy.value = "1"
      item.querySelectorAll("input, textarea, select, button").forEach(el => {
        const n = el.getAttribute("name") || ""
        if (/\[_destroy\]$/.test(n) || /\[id\]$/.test(n)) return
        el.disabled = true
      })
      item.setAttribute("data-removed", "true")
      item.style.display = "none"
    })
  }
}
