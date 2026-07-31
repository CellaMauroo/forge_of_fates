import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["card", "input"]

  choose(event) {
    const card = event.currentTarget
    this.cardTargets.forEach((item) => item.classList.remove("border-amber-500", "border-violet-500", "ring-1", "ring-amber-500/40", "bg-amber-500/5", "bg-violet-500/5"))
    card.classList.add("border-amber-500", "ring-1", "ring-amber-500/40")
    card.querySelector("input").checked = true
  }
}
