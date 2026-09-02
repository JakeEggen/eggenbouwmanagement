import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["toggler", "menu"]

  close() {
    if (window.getComputedStyle(this.togglerTarget).display === "none") return
    if (this.togglerTarget.getAttribute("aria-expanded") !== "true") return

    window.bootstrap?.Collapse.getOrCreateInstance(this.menuTarget).hide()
  }
}
