class ClassSpellcastingProgression < ApplicationRecord
  belongs_to :dnd_class, class_name: "DndClass"

  validates :class_level, inclusion: { in: 1..20 }
end
