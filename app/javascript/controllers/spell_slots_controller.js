import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["slot"]

  async toggle(event) {
    const slot = event.currentTarget
    const spent = slot.dataset.spent !== "true"
    slot.dataset.spent = spent
    slot.classList.toggle("border-violet-500/50", !spent)
    slot.classList.toggle("bg-violet-500/15", !spent)
    slot.classList.toggle("text-violet-400", !spent)
    slot.classList.toggle("border-slate-700", spent)
    slot.classList.toggle("bg-slate-950", spent)
    slot.classList.toggle("text-slate-600", spent)
    await fetch(this.urlValue, { method: "PATCH", headers: { "Content-Type": "application/json", "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content }, body: JSON.stringify({ pool: slot.dataset.pool, level: slot.dataset.level, slot: slot.dataset.slot, spent }) })
  }
}
