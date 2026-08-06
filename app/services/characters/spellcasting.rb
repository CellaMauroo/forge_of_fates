class Characters::Spellcasting
  POOLS = %w[spellcasting pact_magic].freeze

  def initialize(character)
    @character = character
  end

  def class_choices
    @character.character_classes.to_a.filter_map do |character_class|
      klass = character_class.dnd_class
      next unless klass&.spellcasting_available_at?(character_class.class_level)

      progression = klass.spellcasting_progression_at(character_class.class_level)
      next unless progression

      { character_class: character_class, klass: klass, level: character_class.class_level, progression: progression }
    end
  end

  def accessible_class_ids
    class_choices.map { |choice| choice[:klass].id }
  end

  def available_spells
    Spell.joins(:class_spells).where(class_spells: { class_id: accessible_class_ids }).distinct
  end

  def allowed_for?(spell, klass)
    choice = class_choices.find { |item| item[:klass].id == klass.id }
    choice.present? &&
      spell_available_at_class_level?(spell, choice[:progression], klass) &&
      ClassSpell.exists?(class_id: klass.id, spell_id: spell.id)
  end

  def selection_limit_for(klass, cantrip: false, spell: nil)
    choice = class_choices.find { |item| item[:klass].id == klass.id }
    return 0 unless choice

    progression = choice[:progression]
    bucket = selection_bucket_for(spell, klass)
    return progression.cantrip_limit if cantrip || bucket == :cantrips

    case klass.spell_selection_mode
    when "ability_limited"
      [ progression.spell_limit + @character.ability_modifier(klass.primary_ability.downcase), 1 ].max
    else
      progression.spell_limit
    end
  end

  def selection_limits_for(klass)
    choice = class_choices.find { |item| item[:klass].id == klass.id }
    return { "cantrips" => 0, "spells" => 0 } unless choice

    {
      "cantrips" => selection_limit_for(klass, cantrip: true),
      "spells" => selection_limit_for(klass)
    }
  end

  def selection_bucket_for(spell, klass)
    return :spells unless spell
    return :cantrips if spell.level.zero?

    choice = class_choices.find { |item| item[:klass].id == klass.id }
    return :spells unless choice

    :spells
  end

  def selections_for(klass, cantrip: nil, bucket: nil)
    @character.character_spells.includes(:spell).select do |selection|
      next false unless selection.source_class_id == klass.id

      bucket ? selection_bucket_for(selection.spell, klass) == bucket : selection.spell.level.zero? == cantrip
    end
  end

  def can_add?(spell, klass, replacing_spell_id: nil)
    return false unless allowed_for?(spell, klass)

    bucket = selection_bucket_for(spell, klass)
    chosen = selections_for(klass, bucket: bucket).reject { |item| item.spell_id == replacing_spell_id.to_i }
    chosen.size < selection_limit_for(klass, spell: spell)
  end

  def slot_pools
    {
      "spellcasting" => normal_slots,
      "pact_magic" => pact_slots
    }.reject { |_pool, slots| slots.empty? }
  end

  private

    def normal_slots
      normal_choices = class_choices.reject { |choice| choice[:klass].spellcasting_type == "pact" }
      return {} if normal_choices.empty?
      return progression_slots(normal_choices.first[:progression]) if normal_choices.one?

      caster_level = normal_choices.sum do |choice|
        case choice[:klass].spellcasting_type
        when "full" then choice[:level]
        when "half" then choice[:level] / 2
        else 0
        end
      end
      MulticlassSpellSlot.find_by(combined_caster_level: caster_level)&.slots || {}
    end

    def progression_slots(progression)
      progression.spell_slots.each_with_object({}) do |(level, count), slots|
        count = count.to_i
        slots[level.to_i] = count if count.positive?
      end
    end

    def pact_slots
      choice = class_choices.find { |item| item[:klass].spellcasting_type == "pact" }
      return {} unless choice

      progression = choice[:progression]
      return {} if progression.pact_slot_count.zero?

      { progression.pact_slot_level => progression.pact_slot_count }
    end

    def spell_available_at_class_level?(spell, progression, klass)
      spell.level <= progression.highest_spell_level
    end
end
