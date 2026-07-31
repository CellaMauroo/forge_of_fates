class CharacterProficiency < ApplicationRecord
  self.primary_key = %i[character_id proficiency_id]

  belongs_to :character
  belongs_to :proficiency
end
