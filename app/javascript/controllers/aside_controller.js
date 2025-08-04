import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["btn"]

  connect() {
    this.updateActive()
    window.addEventListener("turbo:load", this.updateActiveBound = this.updateActive.bind(this))
  }

  disconnect() {
    window.removeEventListener("turbo:load", this.updateActiveBound)
  }

  updateActive() {
    const path = window.location.pathname

    this.btnTargets.forEach(btn => {
      const tab = btn.dataset.tab
      if (!tab) return

      if (path.includes("/pages")) {
        btn.classList.remove("active")
        return
      }

      const isMatch = this.urlMatchesTab(path, tab)
      btn.classList.toggle("active", isMatch)
    })
  }

  urlMatchesTab(path, tab) {
    switch (tab) {
      case "public":
        return path === "/"
      case "login":
        return path.startsWith("/users/sign_in")
      case "signup":
        return path.startsWith("/users/sign_up")
      case "settings":
        return path.startsWith("/users/edit")
      case "admin-edit":
        return path.startsWith("/admin") && path.includes("/edit")
      case "edit":
        return path.startsWith("/users/edit")
      case "home":
        return path === "/" || path === "/admin" || path === "/admin/sites"
      default:
        return false
    }
  }
}
