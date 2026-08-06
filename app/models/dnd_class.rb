class DndClass < ApplicationRecord
  self.table_name = "classes"

  has_many :character_classes, foreign_key: :class_id, inverse_of: :dnd_class
  has_many :class_spells, foreign_key: :class_id, dependent: :delete_all
  has_many :spells, through: :class_spells
  has_many :spellcasting_progressions, class_name: "ClassSpellcastingProgression", foreign_key: :dnd_class_id, dependent: :delete_all

  def spellcasting_available_at?(level)
    case spellcasting_type
    when "full", "pact"
      level.to_i >= 1
    when "half"
      level.to_i >= 2
    else
      false
    end
  end

  def spellcasting_progression_at(level)
    spellcasting_progressions.find { |progression| progression.class_level == level.to_i } ||
      spellcasting_progressions.find_by(class_level: level)
  end

  def caster_ability
    primary_ability.downcase.to_sym
  end
end
