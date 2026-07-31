class CharacterClass < ApplicationRecord
  belongs_to :character
  belongs_to :dnd_class, class_name: "DndClass", foreign_key: :class_id
  belongs_to :subclass, optional: true
end
