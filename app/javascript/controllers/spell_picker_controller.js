import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["card", "input", "count", "search", "classFilter", "schoolFilter", "filterButton", "source", "limit"]
  static values = { limits: Object }

  connect() {
    this.level = "all"
    this.refresh()
  }

  select(event) {
    const input = event.currentTarget
    const card = input.closest("[data-spell-picker-target~='card']")

    if (input.checked && !this.canUseSource(card, this.sourceFor(card))) input.checked = false

    this.refresh()
  }

  sourceChanged(event) {
    const source = event.currentTarget
    const card = source.closest("[data-spell-picker-target~='card']")
    const input = card.querySelector("input[type='checkbox']")

    if (input.checked && !this.canUseSource(card, source.value)) {
      source.value = card.dataset.selectedSource || card.dataset.defaultSource
    } else {
      card.dataset.selectedSource = source.value
    }

    this.refresh()
  }

  filter(event) {
    this.level = event.currentTarget.dataset.level
    this.updateFilterButtons()
    this.applyFilters()
  }

  filterClass() { this.applyFilters() }
  filterSchool() { this.applyFilters() }
  search() { this.applyFilters() }

  applyFilters() {
    const level = this.level || "all"
    const classId = this.hasClassFilterTarget ? this.classFilterTarget.value : "all"
    const school = this.hasSchoolFilterTarget ? this.schoolFilterTarget.value : "all"
    const search = this.hasSearchTarget ? this.searchTarget.value.trim().toLowerCase() : ""

    this.cardTargets.forEach((card) => {
      const matchesLevel = level === "all" || card.dataset.level === level
      const matchesClass = classId === "all" || card.dataset.classes.split(",").includes(classId)
      const matchesSchool = school === "all" || card.dataset.school === school
      const matchesSearch = !search || card.dataset.name.includes(search)
      card.hidden = !(matchesLevel && matchesClass && matchesSchool && matchesSearch)
    })
  }

  refresh() {
    const counts = this.selectionCounts()
    if (this.hasCountTarget) this.countTarget.textContent = this.inputTargets.filter((input) => input.checked).length

    this.limitTargets.forEach((target) => {
      const classId = target.dataset.classId
      const bucket = target.dataset.bucket
      const limit = this.limitFor(classId, bucket)
      target.textContent = `${counts[this.countKey(classId, bucket)] || 0}/${limit} ${this.bucketLabel(bucket)}`
    })

    this.cardTargets.forEach((card) => {
      const input = card.querySelector("input[type='checkbox']")
      const selected = input.checked
      const canSelect = this.sourceIdsFor(card).some((classId) => this.canUseSource(card, classId))

      if (selected) card.dataset.selectedSource = this.sourceFor(card)
      input.disabled = !selected && !canSelect
      card.classList.toggle("border-slate-800", !selected)
      card.classList.toggle("border-violet-500", selected)
      card.classList.toggle("bg-violet-500/5", selected)
      card.classList.toggle("ring-1", selected)
      card.classList.toggle("ring-violet-500/40", selected)
      card.classList.toggle("opacity-50", !selected && !canSelect)
      card.classList.toggle("cursor-not-allowed", !selected && !canSelect)
    })

    this.updateFilterButtons()
    this.applyFilters()
  }

  updateFilterButtons() {
    this.filterButtonTargets.forEach((button) => {
      const active = button.dataset.level === (this.level || "all")
      button.setAttribute("aria-selected", active.toString())
      button.classList.toggle("bg-violet-600", active)
      button.classList.toggle("text-white", active)
      button.classList.toggle("bg-slate-900", !active)
      button.classList.toggle("text-slate-400", !active)
    })
  }

  selectionCounts(excludedCard = null) {
    return this.cardTargets.reduce((counts, card) => {
      if (card === excludedCard) return counts

      const input = card.querySelector("input[type='checkbox']")
      if (!input.checked) return counts

      const classId = this.sourceFor(card)
      const bucket = this.bucketFor(card, classId)
      const key = this.countKey(classId, bucket)
      counts[key] = (counts[key] || 0) + 1
      return counts
    }, {})
  }

  canUseSource(card, classId) {
    const bucket = this.bucketFor(card, classId)
    const current = this.selectionCounts(card)[this.countKey(classId, bucket)] || 0
    return current < this.limitFor(classId, bucket)
  }

  sourceFor(card) {
    const source = card.querySelector("[data-spell-picker-target~='source']")
    return source ? source.value : card.dataset.defaultSource
  }

  sourceIdsFor(card) {
    const classIds = card.dataset.availableClasses === undefined ? card.dataset.classes : card.dataset.availableClasses
    return classIds.split(",").filter(Boolean)
  }

  bucketFor(card, classId) {
    const level = Number(card.dataset.level)
    if (level === 0) return "cantrips"

    return "spells"
  }

  limitFor(classId, bucket) {
    return Number(this.limitsValue[classId]?.[bucket] || 0)
  }

  countKey(classId, bucket) {
    return `${classId}:${bucket}`
  }

  bucketLabel(bucket) {
    if (bucket === "cantrips") return "truques"
    return "magias"
  }
}
