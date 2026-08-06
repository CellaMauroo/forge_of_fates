class Spell < ApplicationRecord
  has_many :character_spells, dependent: :restrict_with_exception
  has_many :class_spells, dependent: :delete_all
  has_many :dnd_classes, through: :class_spells

  validates :slug, presence: true, uniqueness: true
end
