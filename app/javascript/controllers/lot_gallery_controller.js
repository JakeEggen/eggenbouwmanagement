import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "main", "thumb", "lightbox", "lightboxImage", "lightboxThumb", "counter", "close", "hint" ]

  connect() {
    this.index = 0
    this.boundKeydown = this.keydown.bind(this)
    this.resetZoom(false)
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
    this.resetZoom(false)
    this.closeTarget.focus()
  }

  close() {
    this.resetZoom(false)

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
    if (this.zoomed) return
    this.touchX = event.changedTouches[0].screenX
  }

  touchEnd(event) {
    if (this.zoomed || this.touchX === undefined) return

    const dx = event.changedTouches[0].screenX - this.touchX
    this.touchX = undefined
    if (Math.abs(dx) < 40) return

    this.suppressClick = true
    dx < 0 ? this.next() : this.prev()
  }

  toggleZoom(event) {
    event.preventDefault()
    event.stopPropagation()
    this.zoomed ? this.resetZoom() : this.zoomTo(event)
  }

  pointerDown(event) {
    if (!this.zoomed || event.button !== 0) return

    this.dragging = true
    this.didDrag = false
    this.pointerOriginX = event.clientX
    this.pointerOriginY = event.clientY
    this.dragStartX = event.clientX - this.translateX
    this.dragStartY = event.clientY - this.translateY
    event.currentTarget.classList.add("is-dragging")
    event.currentTarget.setPointerCapture(event.pointerId)
  }

  pointerMove(event) {
    if (!this.dragging) return

    const distance = Math.hypot(
      event.clientX - this.pointerOriginX,
      event.clientY - this.pointerOriginY
    )
    if (distance > 4) this.didDrag = true
    if (!this.didDrag) return

    this.translateX = event.clientX - this.dragStartX
    this.translateY = event.clientY - this.dragStartY
    this.applyZoom(false)
  }

  pointerUp() {
    if (this.didDrag) this.suppressClick = true
    this.dragging = false
    this.didDrag = false
    if (this.hasLightboxImageTarget) {
      this.lightboxImageTarget.classList.remove("is-dragging")
    }
  }

  keydown(event) {
    if (this.lightboxTarget.hidden) return

    if (event.key === "Escape") {
      event.preventDefault()
      this.zoomed ? this.resetZoom() : this.close()
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

    if (this.hasMainTarget) {
      this.mainTarget.src = slide.src
      this.mainTarget.alt = slide.alt
    }
    this.lightboxImageTarget.src = slide.src
    this.lightboxImageTarget.alt = slide.alt
    const label = `${this.index + 1} / ${slides.length}`
    this.counterTarget.textContent = label
    if (this.hasHintTarget) this.hintTarget.textContent = label

    this.thumbTargets.forEach((thumb, i) => {
      if (thumb.classList.contains("lot-gallery__thumb")) {
        thumb.classList.toggle("is-active", i === this.index)
      }
    })
    this.lightboxThumbTargets.forEach((thumb, i) => {
      thumb.classList.toggle("is-active", i === this.index)
    })

    this.resetZoom(false)
  }

  zoomTo(event) {
    const img = this.lightboxImageTarget
    const rect = img.getBoundingClientRect()
    const clickX = event.clientX - rect.left - rect.width / 2
    const clickY = event.clientY - rect.top - rect.height / 2

    this.zoomed = true
    this.scale = 2.4
    this.translateX = clickX * (1 - this.scale)
    this.translateY = clickY * (1 - this.scale)
    this.applyZoom()
  }

  resetZoom(animate = true) {
    this.zoomed = false
    this.dragging = false
    this.didDrag = false
    this.scale = 1
    this.translateX = 0
    this.translateY = 0
    this.applyZoom(animate)
  }

  applyZoom(animate = true) {
    if (!this.hasLightboxImageTarget) return

    const img = this.lightboxImageTarget
    img.style.transition = animate ? "transform 0.22s ease" : "none"
    img.style.transform = `translate(${this.translateX}px, ${this.translateY}px) scale(${this.scale})`
    img.classList.toggle("is-zoomed", this.zoomed)
    if (!this.zoomed) img.classList.remove("is-dragging")
  }

  get slides() {
    return this.thumbTargets.map((thumb) => ({
      src: thumb.dataset.src,
      alt: thumb.dataset.alt
    }))
  }
}
