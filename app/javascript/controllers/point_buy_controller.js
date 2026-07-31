import { Controller } from "@hotwired/stimulus"

const costs = { 8: 0, 9: 1, 10: 2, 11: 3, 12: 4, 13: 5, 14: 7, 15: 9 }

export default class extends Controller {
  static targets = ["card", "input", "base", "bonus", "final", "modifier", "remaining"]
  static values = { bonuses: Object }

  connect() { this.refresh() }

  increment(event) { this.change(event, 1) }
  decrement(event) { this.change(event, -1) }

  change(event, amount) {
    const card = event.currentTarget.closest("[data-point-buy-target='card']")
    const input = card.querySelector("input")
    const next = Number(input.value) + amount
    if (next < 8 || next > 15) return
    const projected = this.totalCost() - costs[Number(input.value)] + costs[next]
    if (projected > 27) return
    input.value = next
    this.refresh()
  }

  refresh() {
    let spent = 0
    this.cardTargets.forEach((card) => {
      const ability = card.dataset.ability
      const value = Number(card.querySelector("input").value)
      const bonus = Number(this.bonusesValue[ability] || 0)
      const finalValue = value + bonus
      spent += costs[value]
      card.querySelector("[data-point-buy-target='base']").textContent = value
      card.querySelector("[data-point-buy-target='bonus']").textContent = bonus ? `+${bonus}` : ""
      card.querySelector("[data-point-buy-target='final']").textContent = finalValue
      const modifier = Math.floor((finalValue - 10) / 2)
      card.querySelector("[data-point-buy-target='modifier']").textContent = `mod ${modifier >= 0 ? "+" : ""}${modifier}`
    })
    this.remainingTarget.textContent = 27 - spent
  }

  totalCost() { return this.inputTargets.reduce((sum, input) => sum + costs[Number(input.value)], 0) }
}
