# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_07_29_184252) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "abilities", primary_key: "code", id: :string, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "backgrounds", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "feature_description"
    t.string "feature_name"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_backgrounds_on_name", unique: true
  end

  create_table "character_classes", force: :cascade do |t|
    t.bigint "character_id", null: false
    t.bigint "class_id", null: false
    t.integer "class_level", default: 1, null: false
    t.datetime "created_at", null: false
    t.boolean "is_primary_class", default: false, null: false
    t.bigint "subclass_id"
    t.datetime "updated_at", null: false
    t.index ["character_id", "class_id"], name: "index_character_classes_on_character_id_and_class_id", unique: true
    t.index ["character_id"], name: "index_character_classes_on_character_id"
    t.index ["class_id"], name: "index_character_classes_on_class_id"
    t.index ["subclass_id"], name: "index_character_classes_on_subclass_id"
  end

  create_table "character_feature_choices", force: :cascade do |t|
    t.bigint "character_id", null: false
    t.string "choice_key", null: false
    t.string "choice_value", null: false
    t.datetime "created_at", null: false
    t.bigint "feature_id", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_character_feature_choices_on_character_id"
    t.index ["feature_id"], name: "index_character_feature_choices_on_feature_id"
  end

  create_table "character_level_histories", force: :cascade do |t|
    t.string "asi_ability_1"
    t.string "asi_ability_2"
    t.integer "asi_bonus_1"
    t.integer "asi_bonus_2"
    t.bigint "character_id", null: false
    t.integer "character_level", null: false
    t.bigint "class_id", null: false
    t.datetime "created_at", null: false
    t.bigint "feat_id"
    t.integer "hp_gained", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id", "character_level"], name: "idx_on_character_id_character_level_07b8738c8d", unique: true
    t.index ["character_id"], name: "index_character_level_histories_on_character_id"
    t.index ["class_id"], name: "index_character_level_histories_on_class_id"
    t.index ["feat_id"], name: "index_character_level_histories_on_feat_id"
  end

  create_table "character_proficiencies", primary_key: ["character_id", "proficiency_id"], force: :cascade do |t|
    t.bigint "character_id", null: false
    t.datetime "created_at", null: false
    t.bigint "proficiency_id", null: false
    t.float "proficiency_multiplier", default: 1.0, null: false
    t.string "source_type", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_character_proficiencies_on_character_id"
    t.index ["proficiency_id"], name: "index_character_proficiencies_on_proficiency_id"
  end

  create_table "character_spells", primary_key: ["character_id", "spell_id"], force: :cascade do |t|
    t.bigint "character_id", null: false
    t.datetime "created_at", null: false
    t.boolean "is_always_prepared", default: false
    t.boolean "is_prepared", default: false
    t.bigint "source_class_id"
    t.bigint "spell_id", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_character_spells_on_character_id"
    t.index ["source_class_id"], name: "index_character_spells_on_source_class_id"
    t.index ["spell_id"], name: "index_character_spells_on_spell_id"
  end

  create_table "characters", force: :cascade do |t|
    t.string "alignment"
    t.bigint "background_id", null: false
    t.text "bonds"
    t.integer "cha_base", default: 8, null: false
    t.string "character_name", null: false
    t.integer "con_base", default: 8, null: false
    t.datetime "created_at", null: false
    t.integer "dex_base", default: 8, null: false
    t.integer "experience_points", default: 0, null: false
    t.text "flaws"
    t.integer "hp_current", null: false
    t.integer "hp_temp", default: 0
    t.text "ideals"
    t.integer "int_base", default: 8, null: false
    t.text "lore"
    t.text "personality_traits"
    t.string "player_name"
    t.bigint "race_id", null: false
    t.integer "str_base", default: 8, null: false
    t.bigint "subrace_id"
    t.datetime "updated_at", null: false
    t.integer "wis_base", default: 8, null: false
    t.index ["background_id"], name: "index_characters_on_background_id"
    t.index ["race_id"], name: "index_characters_on_race_id"
    t.index ["subrace_id"], name: "index_characters_on_subrace_id"
  end

  create_table "class_multiclass_requirements", primary_key: ["class_id", "ability_code"], force: :cascade do |t|
    t.string "ability_code", null: false
    t.bigint "class_id", null: false
    t.datetime "created_at", null: false
    t.integer "minimum_score", default: 13, null: false
    t.datetime "updated_at", null: false
    t.index ["class_id"], name: "index_class_multiclass_requirements_on_class_id"
  end

  create_table "class_spells", primary_key: ["class_id", "spell_id"], force: :cascade do |t|
    t.bigint "class_id", null: false
    t.bigint "spell_id", null: false
    t.index ["class_id"], name: "index_class_spells_on_class_id"
    t.index ["spell_id"], name: "index_class_spells_on_spell_id"
  end

  create_table "classes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "hit_die", null: false
    t.string "name", null: false
    t.string "primary_ability", null: false
    t.string "spellcasting_type", default: "none", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_classes_on_name", unique: true
  end

  create_table "feats", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.text "prerequisite_description"
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_feats_on_name", unique: true
  end

  create_table "feature_effects", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "effect_type", null: false
    t.bigint "feature_id", null: false
    t.string "target_code"
    t.datetime "updated_at", null: false
    t.float "value_num", default: 0.0
    t.text "value_text"
    t.index ["feature_id"], name: "index_feature_effects_on_feature_id"
  end

  create_table "features", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "level_required", default: 1, null: false
    t.string "name", null: false
    t.integer "source_id", null: false
    t.string "source_type", null: false
    t.datetime "updated_at", null: false
  end

  create_table "level_progressions", primary_key: "level", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "experience_points", null: false
    t.integer "proficiency_bonus", null: false
    t.datetime "updated_at", null: false
  end

  create_table "multiclass_spell_slots", primary_key: "combined_caster_level", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "slot_lvl_1", default: 0, null: false
    t.integer "slot_lvl_2", default: 0, null: false
    t.integer "slot_lvl_3", default: 0, null: false
    t.integer "slot_lvl_4", default: 0, null: false
    t.integer "slot_lvl_5", default: 0, null: false
    t.integer "slot_lvl_6", default: 0, null: false
    t.integer "slot_lvl_7", default: 0, null: false
    t.integer "slot_lvl_8", default: 0, null: false
    t.integer "slot_lvl_9", default: 0, null: false
    t.datetime "updated_at", null: false
  end

  create_table "proficiencies", force: :cascade do |t|
    t.string "ability_code"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.string "proficiency_type", null: false
    t.datetime "updated_at", null: false
  end

  create_table "proficiency_option_items", primary_key: ["proficiency_option_id", "proficiency_id"], force: :cascade do |t|
    t.bigint "proficiency_id", null: false
    t.bigint "proficiency_option_id", null: false
    t.index ["proficiency_id"], name: "index_proficiency_option_items_on_proficiency_id"
    t.index ["proficiency_option_id"], name: "index_proficiency_option_items_on_proficiency_option_id"
  end

  create_table "proficiency_options", force: :cascade do |t|
    t.integer "choices_count", default: 1, null: false
    t.datetime "created_at", null: false
    t.string "description"
    t.integer "source_id", null: false
    t.string "source_type", null: false
    t.datetime "updated_at", null: false
  end

  create_table "race_ability_bonuses", force: :cascade do |t|
    t.string "ability_code", null: false
    t.integer "bonus_value", null: false
    t.datetime "created_at", null: false
    t.boolean "is_choice", default: false, null: false
    t.bigint "race_id"
    t.bigint "subrace_id"
    t.datetime "updated_at", null: false
    t.index ["race_id"], name: "index_race_ability_bonuses_on_race_id"
    t.index ["subrace_id"], name: "index_race_ability_bonuses_on_subrace_id"
  end

  create_table "races", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.string "size", null: false
    t.float "speed_meters", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_races_on_name", unique: true
  end

  create_table "spells", force: :cascade do |t|
    t.string "casting_time"
    t.string "components"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "duration"
    t.boolean "is_ritual", default: false
    t.integer "level", null: false
    t.string "name", null: false
    t.string "range_text"
    t.string "school", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subclasses", force: :cascade do |t|
    t.bigint "class_id", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["class_id"], name: "index_subclasses_on_class_id"
  end

  create_table "subraces", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.bigint "race_id", null: false
    t.datetime "updated_at", null: false
    t.index ["race_id"], name: "index_subraces_on_race_id"
  end

  add_foreign_key "character_classes", "characters"
  add_foreign_key "character_classes", "classes"
  add_foreign_key "character_classes", "subclasses"
  add_foreign_key "character_feature_choices", "characters"
  add_foreign_key "character_feature_choices", "features"
  add_foreign_key "character_level_histories", "abilities", column: "asi_ability_1", primary_key: "code"
  add_foreign_key "character_level_histories", "abilities", column: "asi_ability_2", primary_key: "code"
  add_foreign_key "character_level_histories", "characters"
  add_foreign_key "character_level_histories", "classes"
  add_foreign_key "character_level_histories", "feats"
  add_foreign_key "character_proficiencies", "characters"
  add_foreign_key "character_proficiencies", "proficiencies"
  add_foreign_key "character_spells", "characters"
  add_foreign_key "character_spells", "classes", column: "source_class_id"
  add_foreign_key "character_spells", "spells"
  add_foreign_key "characters", "backgrounds"
  add_foreign_key "characters", "races"
  add_foreign_key "characters", "subraces"
  add_foreign_key "class_multiclass_requirements", "abilities", column: "ability_code", primary_key: "code"
  add_foreign_key "class_multiclass_requirements", "classes"
  add_foreign_key "class_spells", "classes"
  add_foreign_key "class_spells", "spells"
  add_foreign_key "classes", "abilities", column: "primary_ability", primary_key: "code"
  add_foreign_key "feature_effects", "features"
  add_foreign_key "proficiencies", "abilities", column: "ability_code", primary_key: "code"
  add_foreign_key "proficiency_option_items", "proficiencies"
  add_foreign_key "proficiency_option_items", "proficiency_options"
  add_foreign_key "race_ability_bonuses", "abilities", column: "ability_code", primary_key: "code"
  add_foreign_key "race_ability_bonuses", "races"
  add_foreign_key "race_ability_bonuses", "subraces"
  add_foreign_key "subclasses", "classes"
  add_foreign_key "subraces", "races"
end
