import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["toggle", "secondary", "primaryLevel", "levelOutput"]

  connect() { this.toggle() }
  toggle() { this.secondaryTarget.classList.toggle("hidden", !this.toggleTarget.checked) }
  updateLevel() { this.levelOutputTarget.textContent = this.primaryLevelTarget.value }
}
