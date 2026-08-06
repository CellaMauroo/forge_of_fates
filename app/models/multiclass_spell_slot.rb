class MulticlassSpellSlot < ApplicationRecord
  self.primary_key = :combined_caster_level

  def slots
    (1..9).each_with_object({}) do |level, values|
      count = public_send("slot_lvl_#{level}")
      values[level] = count if count.positive?
    end
  end
end
