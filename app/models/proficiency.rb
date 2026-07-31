class Proficiency < ApplicationRecord
  has_many :character_proficiencies
  has_many :characters, through: :character_proficiencies
end
