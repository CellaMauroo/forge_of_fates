import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["card", "input", "count"]
  connect() { this.refresh() }
  select() { requestAnimationFrame(() => this.refresh()) }
  filter(event) {
    const level = event.currentTarget.dataset.level
    this.cardTargets.forEach((card) => { card.hidden = level !== "all" && card.dataset.level !== level })
  }
  refresh() {
    this.countTarget.textContent = this.inputTargets.filter((input) => input.checked).length
    this.cardTargets.forEach((card) => {
      const selected = card.querySelector("input").checked
      card.classList.toggle("border-slate-800", !selected)
      card.classList.toggle("border-violet-500", selected)
      card.classList.toggle("bg-violet-500/5", selected)
      card.classList.toggle("ring-1", selected)
      card.classList.toggle("ring-violet-500/40", selected)
    })
  }
}
