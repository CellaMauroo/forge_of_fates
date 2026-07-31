import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "icon"]

  toggle() {
    const isPassword = this.inputTarget.type === "password"

    this.inputTarget.type = isPassword ? "text" : "password"
    this.element.setAttribute("aria-pressed", String(isPassword))
    this.element.setAttribute("aria-label", isPassword ? "Ocultar senha" : "Mostrar senha")
    this.iconTarget.textContent = isPassword ? "🙈" : "👁"
  }

  connect() {
    this.element.setAttribute("aria-label", "Mostrar senha")
    this.element.setAttribute("aria-pressed", "false")
  }
}
