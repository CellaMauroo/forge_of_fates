class Characters::CardComponent < ViewComponent::Base
  TONES = [
    { avatar: "border-rose-500/30 bg-rose-500/10 text-rose-400", accent: "bg-rose-400" },
    { avatar: "border-amber-500/30 bg-amber-500/10 text-amber-400", accent: "bg-amber-400" },
    { avatar: "border-cyan-500/30 bg-cyan-500/10 text-cyan-400", accent: "bg-cyan-400" },
    { avatar: "border-violet-500/30 bg-violet-500/10 text-violet-400", accent: "bg-violet-400" }
  ].freeze

  def initialize(character:)
    @character = character
  end

  private
    attr_reader :character

    def tone
      TONES[character.id.to_i % TONES.length]
    end

    def character_initial
      character.character_name.to_s.first&.upcase || "?"
    end

    def class_label
      level = character.primary_character_class&.class_level
      [character.primary_class_name, level && "#{level}º nível"].compact.join(" · ")
    end

    def spell_count
      character.character_spells.size
    end

    def ability_modifier(ability)
      modifier = character.ability_modifier(ability)
      modifier.positive? ? "+#{modifier}" : modifier.to_s
    end

    def updated_at_label
      helpers.time_ago_in_words(character.updated_at)
    end
end
