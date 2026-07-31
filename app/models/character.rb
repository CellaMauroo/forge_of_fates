class Character < ApplicationRecord
  ABILITIES = %i[str dex con int wis cha].freeze

  belongs_to :user, optional: true
  belongs_to :race
  belongs_to :subrace, optional: true
  belongs_to :background

  has_many :character_classes
  has_many :character_spells
  has_many :spells, through: :character_spells
  has_many :character_proficiencies
  has_many :proficiencies, through: :character_proficiencies

  scope :recently_updated, -> { order(updated_at: :desc) }

  def total_level
    character_classes.sum(&:class_level)
  end

  def primary_character_class
    character_classes.find(&:is_primary_class?) || character_classes.max_by(&:class_level)
  end

  def primary_class_name
    primary_character_class&.dnd_class&.name || "Classe não definida"
  end

  def ancestry_name
    subrace&.name.presence || race&.name.presence || "Raça não definida"
  end

  def spellcaster?
    character_classes.any? { |character_class| character_class.dnd_class&.spellcasting_type != "none" }
  end

  def ability_modifier(ability)
    ability = ability.to_sym
    raise ArgumentError, "Habilidade inválida: #{ability}" unless ABILITIES.include?(ability)

    ((public_send("#{ability}_base") - 10) / 2.0).floor
  end

  def speed_in_feet
    return unless race&.speed_meters

    (race.speed_meters * 3.28084).round
  end

  def klass
    primary_character_class&.dnd_class
  end

  def level
    total_level
  end

  def proficiency_bonus
    2 + (([ level, 1 ].max - 1) / 4)
  end

  def armor_class
    10 + ability_modifier(:dex)
  end

  def maximum_hit_points
    return hp_current.to_i if klass.blank?

    [ klass.hit_die + ability_modifier(:con) + ([ level, 1 ].max - 1) * ((klass.hit_die / 2.0) + 1 + ability_modifier(:con)).floor, 1 ].max
  end

  def skill_bonus(skill_name)
    ability = SKILLS.fetch(skill_name.to_s)
    proficiency = proficiencies.any? { |item| item.name == skill_name.to_s }
    ability_modifier(ability) + (proficiency ? proficiency_bonus : 0)
  end

  def spell_slots
    return {} unless spellcaster?

    slots = {
      1 => [ 0, 2, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4 ],
      2 => [ 0, 0, 0, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3 ],
      3 => [ 0, 0, 0, 0, 0, 0, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3 ]
    }
    slots.transform_values { |table| table.fetch([ level, 20 ].min) }.reject { |_, count| count.zero? }
  end

  SKILLS = {
    "Acrobacia" => :dex, "Trato de Animais" => :wis, "Arcanismo" => :int,
    "Atletismo" => :str, "Enganação" => :cha, "História" => :int,
    "Intuição" => :wis, "Intimidação" => :cha, "Investigação" => :int,
    "Medicina" => :wis, "Natureza" => :int, "Percepção" => :wis,
    "Persuasão" => :cha, "Prestidigitação" => :dex, "Religião" => :int,
    "Sobrevivência" => :wis, "Furtividade" => :dex
  }.freeze
end
