import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["current", "bar"]
  static values = { url: String, current: Number, maximum: Number }

  damage() { this.update(this.currentValue - 1) }
  heal() { this.update(this.currentValue + 1) }

  async update(value) {
    this.currentValue = Math.max(0, Math.min(this.maximumValue, value))
    this.currentTarget.textContent = this.currentValue
    this.barTarget.style.width = `${(this.currentValue / this.maximumValue) * 100}%`
    await fetch(this.urlValue, { method: "PATCH", headers: { "Content-Type": "application/json", "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content }, body: JSON.stringify({ hp_current: this.currentValue }) })
  }
}
