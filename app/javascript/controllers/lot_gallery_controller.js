import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "main", "thumb" ]

  show(event) {
    const button = event.currentTarget
    this.mainTarget.src = button.dataset.src
    this.mainTarget.alt = button.dataset.alt
    this.thumbTargets.forEach((thumb) => {
      thumb.classList.toggle("is-active", thumb === button)
    })
  }
}
