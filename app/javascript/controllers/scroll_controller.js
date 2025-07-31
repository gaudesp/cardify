// controllers/scroll_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["section", "item"]
  static values = { site: String }

  connect() {
    if (window.innerWidth >= 1100) return

    this.navHeight = document.querySelector("nav")?.offsetHeight || 0
    this.currentSlug = null
    this.manualScroll = false
    this.scrollTopBtn = document.getElementById("scrollTopBtn")

    this._onScroll = this._onScroll.bind(this)
    this._onScrollTopClick = this._onScrollTopClick.bind(this)

    window.addEventListener("scroll", this._onScroll)
    if (this.scrollTopBtn) {
      this.scrollTopBtn.addEventListener("click", this._onScrollTopClick)
    }

    const slug = window.location.pathname.split("/")[2]
    if (slug) {
      const section = this.sectionTargets.find(s => s.dataset.slug === slug)
      if (section) {
        this.manualScroll = true
        section.scrollIntoView({ behavior: "auto" })
        this.updateNav(slug)
        this.currentSlug = slug
        setTimeout(() => {
          this.manualScroll = false
          this._onScroll() // 👈 forcer mise à jour après scroll automatique
        }, 300)
        return // 👈 éviter double appel à _onScroll juste après
      }
    }

    this._onScroll() // 👈 cas normal sans slug
  }

  disconnect() {
    window.removeEventListener("scroll", this._onScroll)
    if (this.scrollTopBtn) {
      this.scrollTopBtn.removeEventListener("click", this._onScrollTopClick)
    }
  }

  scrollToSection(event) {
    event.preventDefault()
    const slug = event.currentTarget.dataset.tab
    const section = this.sectionTargets.find(s => s.dataset.slug === slug)
    if (!section) return

    this.manualScroll = true
    section.scrollIntoView({ behavior: "smooth" })
    history.replaceState({}, "", `/${this.siteValue}/${slug}`)
    this.updateNav(slug)
    this.currentSlug = slug

    setTimeout(() => {
      this.manualScroll = false
      this._onScroll()
    }, 500)
  }

  _onScroll() {
    if (this.manualScroll) return

    const firstSection = this.sectionTargets[0]
    if (!firstSection) return

    const firstTop = firstSection.getBoundingClientRect().top
    this._toggleScrollButton()

    if (firstTop > this.navHeight) {
      if (this.currentSlug !== null) {
        history.replaceState({}, "", `/${this.siteValue}`)
        this.updateNav(null)
        this.currentSlug = null
      }
      return
    }

    for (const section of this.sectionTargets) {
      const { top, bottom } = section.getBoundingClientRect()
      const slug = section.dataset.slug

      if (top <= this.navHeight && bottom > this.navHeight) {
        if (slug !== this.currentSlug) {
          history.replaceState({}, "", `/${this.siteValue}/${slug}`)
          this.updateNav(slug)
          this.currentSlug = slug
        }
        return
      }
    }
  }

  _toggleScrollButton() {
    if (!this.scrollTopBtn) return
    const shouldShow = window.scrollY > 100
    this.scrollTopBtn.classList.toggle("show", shouldShow)
  }

  _onScrollTopClick(event) {
    event.preventDefault()
    this.manualScroll = true
    if (this.scrollTopBtn) this.scrollTopBtn.classList.remove("show")
    this.updateNav(null)
    history.replaceState({}, "", `/${this.siteValue}`)
    this.currentSlug = null
    window.scrollTo({ top: 0, behavior: "smooth" })
    setTimeout(() => this.manualScroll = false, 500)
  }

  updateNav(slug) {
    this.itemTargets.forEach(el => {
      el.classList.toggle("active", el.dataset.tab === slug)
    })
  }
}
