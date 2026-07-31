class Characters::AttributeCalculator
  def initialize(character)
    @character = character
  end

  # Mantém os valores escolhidos no Point Buy dentro dos limites aceitos pelo modelo.
  # Bônus raciais podem ser acrescentados futuramente quando houver campos de atributo final.
  def apply!
    Character::ABILITIES.each do |ability|
      attribute = "#{ability}_base"
      @character.public_send("#{attribute}=", @character.public_send(attribute).to_i)
    end

    @character
  end
end
