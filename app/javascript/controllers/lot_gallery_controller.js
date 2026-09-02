import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "main", "thumb", "lightbox", "lightboxImage", "lightboxThumb", "counter", "close", "hint" ]

  connect() {
    this.index = 0
    this.boundKeydown = this.keydown.bind(this)
  }

  disconnect() {
    this.close()
  }

  show(event) {
    this.select(this.thumbTargets.indexOf(event.currentTarget))
  }

  openAt(event) {
    this.select(this.thumbTargets.indexOf(event.currentTarget))
    this.open()
  }

  selectFromLightbox(event) {
    this.select(this.lightboxThumbTargets.indexOf(event.currentTarget))
  }

  open() {
    if (!this.lightboxTarget.hidden) return

    this.lastFocus = document.activeElement
    this.lightboxTarget.hidden = false
    document.body.classList.add("lot-lightbox-open")
    document.addEventListener("keydown", this.boundKeydown)
    this.closeTarget.focus()
  }

  close() {
    if (!this.hasLightboxTarget || this.lightboxTarget.hidden) {
      document.removeEventListener("keydown", this.boundKeydown)
      document.body.classList.remove("lot-lightbox-open")
      return
    }

    this.lightboxTarget.hidden = true
    document.body.classList.remove("lot-lightbox-open")
    document.removeEventListener("keydown", this.boundKeydown)
    this.lastFocus?.focus?.()
  }

  closeOnBackdrop(event) {
    if (this.suppressClick) {
      this.suppressClick = false
      return
    }

    if (
      event.target === this.lightboxTarget ||
      event.target.classList.contains("lot-lightbox__stage")
    ) {
      this.close()
    }
  }

  prev(event) {
    event?.stopPropagation()
    this.select(this.index - 1)
  }

  next(event) {
    event?.stopPropagation()
    this.select(this.index + 1)
  }

  touchStart(event) {
    this.touchX = event.changedTouches[0].screenX
  }

  touchEnd(event) {
    if (this.touchX === undefined) return

    const dx = event.changedTouches[0].screenX - this.touchX
    this.touchX = undefined
    if (Math.abs(dx) < 40) return

    this.suppressClick = true
    dx < 0 ? this.next() : this.prev()
  }

  keydown(event) {
    if (this.lightboxTarget.hidden) return

    if (event.key === "Escape") {
      event.preventDefault()
      this.close()
    } else if (event.key === "ArrowLeft") {
      event.preventDefault()
      this.prev()
    } else if (event.key === "ArrowRight") {
      event.preventDefault()
      this.next()
    }
  }

  select(index) {
    const slides = this.slides
    if (!slides.length) return

    this.index = (index + slides.length) % slides.length
    const slide = slides[this.index]

    this.mainTarget.src = slide.src
    this.mainTarget.alt = slide.alt
    this.lightboxImageTarget.src = slide.src
    this.lightboxImageTarget.alt = slide.alt
    const label = `${this.index + 1} / ${slides.length}`
    this.counterTarget.textContent = label
    if (this.hasHintTarget) this.hintTarget.textContent = label

    this.thumbTargets.forEach((thumb, i) => {
      thumb.classList.toggle("is-active", i === this.index)
    })
    this.lightboxThumbTargets.forEach((thumb, i) => {
      thumb.classList.toggle("is-active", i === this.index)
    })
  }

  get slides() {
    return this.thumbTargets.map((thumb) => ({
      src: thumb.dataset.src,
      alt: thumb.dataset.alt
    }))
  }
}
