class Dashboard::StatCardComponent < ViewComponent::Base
  TONES = {
    amber: "text-amber-400",
    violet: "text-violet-400",
    cyan: "text-cyan-400"
  }.freeze

  def initialize(value:, label:, tone: :amber)
    @value = value
    @label = label
    @tone = TONES.fetch(tone.to_sym, TONES[:amber])
  end
end
