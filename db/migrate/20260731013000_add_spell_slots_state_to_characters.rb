class AddSpellSlotsStateToCharacters < ActiveRecord::Migration[8.1]
  def change
    add_column :characters, :spell_slots_state, :jsonb, default: {}, null: false
  end
end
