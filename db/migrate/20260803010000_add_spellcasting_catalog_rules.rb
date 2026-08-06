class AddSpellcastingCatalogRules < ActiveRecord::Migration[8.1]
  def change
    add_column :spells, :slug, :string
    add_column :spells, :source_book, :string, null: false, default: "phb_2014"
    add_index :spells, :slug, unique: true

    create_table :class_spellcasting_progressions do |t|
      t.references :dnd_class, null: false, foreign_key: { to_table: :classes }, index: false
      t.integer :class_level, null: false
      t.integer :cantrip_limit, null: false, default: 0
      t.integer :spell_limit, null: false, default: 0
      t.integer :highest_spell_level, null: false, default: 0
      t.jsonb :spell_slots, null: false, default: {}
      t.integer :pact_slot_level, null: false, default: 0
      t.integer :pact_slot_count, null: false, default: 0
      t.jsonb :mystic_arcanum_levels, null: false, default: []
      t.timestamps
    end
    add_index :class_spellcasting_progressions, [ :dnd_class_id, :class_level ], unique: true, name: "index_spellcasting_progressions_on_class_and_level"

    add_column :classes, :spell_selection_mode, :string, null: false, default: "none"
  end
end
