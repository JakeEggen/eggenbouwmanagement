import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "item", "button" ]

  filter(event) {
    const category = event.currentTarget.dataset.category || ""

    this.itemTargets.forEach((item) => {
      item.hidden = category !== "" && item.dataset.category !== category
    })

    this.buttonTargets.forEach((button) => {
      const active = button === event.currentTarget
      button.classList.toggle("is-active", active)
      button.setAttribute("aria-pressed", active)
    })
  }
}
