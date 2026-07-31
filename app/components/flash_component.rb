class FlashComponent < ViewComponent::Base
  def initialize(flash:, elevated: false)
    @messages = flash.to_hash.slice("notice", "alert", "warning").compact
    @elevated = elevated
  end

  private

    attr_reader :messages

    def position_class
      @elevated ? "bottom-24" : "bottom-5"
    end

    def tone_for(type)
      case type
      when "alert"
        "border-rose-500/35 bg-rose-500/15 text-rose-100"
      when "warning"
        "border-amber-500/35 bg-amber-500/15 text-amber-100"
      else
        "border-emerald-500/35 bg-emerald-500/15 text-emerald-100"
      end
    end

    def icon_for(type)
      type == "alert" ? "!" : (type == "warning" ? "i" : "✓")
    end
end
