// controllers/scroll_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["section", "item"]
  static values = { site: String }

  connect() {
    if (window.innerWidth < 1100) {
      this.observer = new IntersectionObserver(this.onIntersect.bind(this), {
        root: null,
        threshold: 0.6
      })

      this.sectionTargets.forEach(section => this.observer.observe(section))

      const pathParts = window.location.pathname.split("/")
      const slug = pathParts[2]
      if (slug) {
        this.updateNav(slug)
        const section = document.querySelector(`section[data-slug="${slug}"]`)
        if (section) section.scrollIntoView({ behavior: "auto" })
      }
    }
  }

  disconnect() {
    if (this.observer) this.observer.disconnect()
  }

  scrollToSection(event) {
    event.preventDefault()

    const slug = event.currentTarget.dataset.tab
    const section = document.querySelector(`section[data-slug="${slug}"]`)
    if (section) section.scrollIntoView({ behavior: "smooth" })

    const newPath = `/${this.siteValue}/${slug}`
    history.replaceState({}, "", newPath)
    this.updateNav(slug)
  }

  onIntersect(entries) {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        const slug = entry.target.dataset.slug
        const fullPath = `/${this.siteValue}/${slug}`
        history.replaceState({}, "", fullPath)
        this.updateNav(slug)
      }
    })
  }

  updateNav(slug) {
    this.itemTargets.forEach(el => {
      el.classList.toggle("active", el.dataset.tab === slug)
    })
  }
}
