class ClassSpell < ApplicationRecord
  self.primary_key = %i[ class_id spell_id ]

  belongs_to :dnd_class, class_name: "DndClass", foreign_key: :class_id
  belongs_to :spell
end
