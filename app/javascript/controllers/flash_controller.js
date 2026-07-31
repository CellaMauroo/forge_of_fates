import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.animate(
      [{ opacity: 0, transform: "translateY(24px)" }, { opacity: 1, transform: "translateY(0)" }],
      { duration: 240, easing: "cubic-bezier(0.22, 1, 0.36, 1)" }
    )
    this.timeout = setTimeout(() => this.dismiss(), 5000)
  }

  disconnect() { clearTimeout(this.timeout) }

  dismiss() {
    clearTimeout(this.timeout)
    const animation = this.element.animate(
      [{ opacity: 1, transform: "translateY(0)" }, { opacity: 0, transform: "translateY(24px)" }],
      { duration: 200, easing: "ease-in" }
    )
    animation.finished.then(() => this.element.remove())
  }
}
