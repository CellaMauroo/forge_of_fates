class DndClass < ApplicationRecord
  self.table_name = "classes"

  has_many :character_classes, foreign_key: :class_id, inverse_of: :dnd_class
end
