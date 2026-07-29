class CreateForgeOfFatesSchema < ActiveRecord::Migration[8.1]
  def change
    # ----------------------------------------------------
    # 1. TABELAS DE DOMÍNIO E REGRAS GERAIS
    # ----------------------------------------------------
    create_table :abilities, id: false do |t|
      t.string :code, primary_key: true
      t.string :name, null: false
      t.timestamps
    end

    create_table :level_progressions, id: false do |t|
      t.integer :level, primary_key: true
      t.integer :proficiency_bonus, null: false
      t.integer :experience_points, null: false
      t.timestamps
    end

    create_table :multiclass_spell_slots, id: false do |t|
      t.integer :combined_caster_level, primary_key: true
      t.integer :slot_lvl_1, default: 0, null: false
      t.integer :slot_lvl_2, default: 0, null: false
      t.integer :slot_lvl_3, default: 0, null: false
      t.integer :slot_lvl_4, default: 0, null: false
      t.integer :slot_lvl_5, default: 0, null: false
      t.integer :slot_lvl_6, default: 0, null: false
      t.integer :slot_lvl_7, default: 0, null: false
      t.integer :slot_lvl_8, default: 0, null: false
      t.integer :slot_lvl_9, default: 0, null: false
      t.timestamps
    end

    # ----------------------------------------------------
    # 2. CATÁLOGOS ESTÁTICOS
    # ----------------------------------------------------
    create_table :races do |t|
      t.string :name, null: false, index: { unique: true }
      t.float :speed_meters, null: false
      t.string :size, null: false
      t.text :description
      t.timestamps
    end

    create_table :subraces do |t|
      t.references :race, null: false, foreign_key: true
      t.string :name, null: false
      t.text :description
      t.timestamps
    end

    create_table :race_ability_bonuses do |t|
      t.references :race, foreign_key: true
      t.references :subrace, foreign_key: true
      t.string :ability_code, null: false
      t.integer :bonus_value, null: false
      t.boolean :is_choice, default: false, null: false
      t.timestamps
    end
    add_foreign_key :race_ability_bonuses, :abilities, column: :ability_code, primary_key: :code

    create_table :classes do |t|
      t.string :name, null: false, index: { unique: true }
      t.integer :hit_die, null: false
      t.string :primary_ability, null: false
      t.string :spellcasting_type, default: 'none', null: false
      t.timestamps
    end
    add_foreign_key :classes, :abilities, column: :primary_ability, primary_key: :code

    create_table :subclasses do |t|
      t.references :class, null: false, foreign_key: true
      t.string :name, null: false
      t.text :description
      t.timestamps
    end

    create_table :class_multiclass_requirements, id: false do |t|
      t.references :class, null: false, foreign_key: true
      t.string :ability_code, null: false
      t.integer :minimum_score, default: 13, null: false
      t.timestamps
    end
    add_foreign_key :class_multiclass_requirements, :abilities, column: :ability_code, primary_key: :code
    execute "ALTER TABLE class_multiclass_requirements ADD PRIMARY KEY (class_id, ability_code);"

    create_table :backgrounds do |t|
      t.string :name, null: false, index: { unique: true }
      t.string :feature_name
      t.text :feature_description
      t.timestamps
    end

    create_table :proficiencies do |t|
      t.string :name, null: false
      t.string :proficiency_type, null: false
      t.string :ability_code
      t.timestamps
    end
    add_foreign_key :proficiencies, :abilities, column: :ability_code, primary_key: :code

    create_table :proficiency_options do |t|
      t.string :source_type, null: false
      t.integer :source_id, null: false
      t.integer :choices_count, default: 1, null: false
      t.string :description
      t.timestamps
    end

    create_table :proficiency_option_items, id: false do |t|
      t.references :proficiency_option, null: false, foreign_key: true
      t.references :proficiency, null: false, foreign_key: true
    end
    execute "ALTER TABLE proficiency_option_items ADD PRIMARY KEY (proficiency_option_id, proficiency_id);"

    # ----------------------------------------------------
    # 3. MOTOR DE CARACTERÍSTICAS (FEATURES & EFFECTS)
    # ----------------------------------------------------
    create_table :features do |t|
      t.string :name, null: false
      t.string :source_type, null: false
      t.integer :source_id, null: false
      t.integer :level_required, default: 1, null: false
      t.text :description
      t.timestamps
    end

    create_table :feature_effects do |t|
      t.references :feature, null: false, foreign_key: true
      t.string :effect_type, null: false
      t.string :target_code
      t.float :value_num, default: 0
      t.text :value_text
      t.timestamps
    end

    create_table :feats do |t|
      t.string :name, null: false, index: { unique: true }
      t.text :prerequisite_description
      t.text :description
      t.timestamps
    end

    create_table :spells do |t|
      t.string :name, null: false
      t.integer :level, null: false
      t.string :school, null: false
      t.string :casting_time
      t.string :range_text
      t.string :components
      t.string :duration
      t.boolean :is_ritual, default: false
      t.text :description
      t.timestamps
    end

    create_table :class_spells, id: false do |t|
      t.references :class, null: false, foreign_key: true
      t.references :spell, null: false, foreign_key: true
    end
    execute "ALTER TABLE class_spells ADD PRIMARY KEY (class_id, spell_id);"

    # ----------------------------------------------------
    # 4. INSTÂNCIA DO JOGADOR (PERSONAGEM)
    # ----------------------------------------------------
    create_table :characters do |t|
      t.string :player_name
      t.string :character_name, null: false
      t.integer :experience_points, default: 0, null: false
      t.references :race, null: false, foreign_key: true
      t.references :subrace, foreign_key: true
      t.references :background, null: false, foreign_key: true
      t.string :alignment
      t.integer :str_base, default: 8, null: false
      t.integer :dex_base, default: 8, null: false
      t.integer :con_base, default: 8, null: false
      t.integer :int_base, default: 8, null: false
      t.integer :wis_base, default: 8, null: false
      t.integer :cha_base, default: 8, null: false
      t.integer :hp_current, null: false
      t.integer :hp_temp, default: 0
      t.text :personality_traits
      t.text :ideals
      t.text :bonds
      t.text :flaws
      t.text :lore
      t.timestamps
    end

    create_table :character_classes do |t|
      t.references :character, null: false, foreign_key: true
      t.references :class, null: false, foreign_key: true
      t.references :subclass, foreign_key: true
      t.integer :class_level, default: 1, null: false
      t.boolean :is_primary_class, default: false, null: false
      t.timestamps
    end
    add_index :character_classes, [:character_id, :class_id], unique: true

    create_table :character_level_histories do |t|
      t.references :character, null: false, foreign_key: true
      t.integer :character_level, null: false
      t.references :class, null: false, foreign_key: true
      t.integer :hp_gained, null: false
      t.string :asi_ability_1
      t.integer :asi_bonus_1
      t.string :asi_ability_2
      t.integer :asi_bonus_2
      t.references :feat, foreign_key: true
      t.timestamps
    end
    add_foreign_key :character_level_histories, :abilities, column: :asi_ability_1, primary_key: :code
    add_foreign_key :character_level_histories, :abilities, column: :asi_ability_2, primary_key: :code
    add_index :character_level_histories, [:character_id, :character_level], unique: true

    create_table :character_proficiencies, id: false do |t|
      t.references :character, null: false, foreign_key: true
      t.references :proficiency, null: false, foreign_key: true
      t.float :proficiency_multiplier, default: 1.0, null: false
      t.string :source_type, null: false
      t.timestamps
    end
    execute "ALTER TABLE character_proficiencies ADD PRIMARY KEY (character_id, proficiency_id);"

    create_table :character_spells, id: false do |t|
      t.references :character, null: false, foreign_key: true
      t.references :spell, null: false, foreign_key: true
      t.references :source_class, foreign_key: { to_table: :classes }
      t.boolean :is_prepared, default: false
      t.boolean :is_always_prepared, default: false
      t.timestamps
    end
    execute "ALTER TABLE character_spells ADD PRIMARY KEY (character_id, spell_id);"

    create_table :character_feature_choices do |t|
      t.references :character, null: false, foreign_key: true
      t.references :feature, null: false, foreign_key: true
      t.string :choice_key, null: false
      t.string :choice_value, null: false
      t.timestamps
    end
  end
end