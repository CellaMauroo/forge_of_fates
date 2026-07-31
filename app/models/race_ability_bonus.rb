class RaceAbilityBonus < ApplicationRecord
  self.table_name = "race_ability_bonuses"

  belongs_to :race, optional: true
  belongs_to :subrace, optional: true
end
