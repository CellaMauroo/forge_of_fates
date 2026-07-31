class CharacterSpell < ApplicationRecord
  self.primary_key = %i[ character_id spell_id ]

  belongs_to :character
  belongs_to :spell
  belongs_to :source_class, class_name: "DndClass", optional: true
end
