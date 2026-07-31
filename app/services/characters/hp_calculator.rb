class Characters::HpCalculator
  def initialize(character, dnd_class:)
    @character = character
    @dnd_class = dnd_class
  end

  def calculate
    [@dnd_class.hit_die + @character.ability_modifier(:con), 1].max
  end
end
