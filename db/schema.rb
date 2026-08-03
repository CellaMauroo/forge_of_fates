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

ActiveRecord::Schema[8.1].define(version: 2026_08_03_000000) do
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
    t.jsonb "spell_slots_state", default: {}, null: false
    t.integer "str_base", default: 8, null: false
    t.bigint "subrace_id"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.integer "wis_base", default: 8, null: false
    t.index ["background_id"], name: "index_characters_on_background_id"
    t.index ["race_id"], name: "index_characters_on_race_id"
    t.index ["subrace_id"], name: "index_characters_on_subrace_id"
    t.index ["user_id"], name: "index_characters_on_user_id"
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

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "solid_cable_messages", force: :cascade do |t|
    t.binary "channel", null: false
    t.bigint "channel_hash", null: false
    t.datetime "created_at", null: false
    t.binary "payload", null: false
    t.index ["channel"], name: "index_solid_cable_messages_on_channel"
    t.index ["channel_hash"], name: "index_solid_cable_messages_on_channel_hash"
    t.index ["created_at"], name: "index_solid_cable_messages_on_created_at"
  end

  create_table "solid_cache_entries", force: :cascade do |t|
    t.integer "byte_size", null: false
    t.datetime "created_at", null: false
    t.binary "key", null: false
    t.bigint "key_hash", null: false
    t.binary "value", null: false
    t.index ["byte_size"], name: "index_solid_cache_entries_on_byte_size"
    t.index ["key_hash", "byte_size"], name: "index_solid_cache_entries_on_key_hash_and_byte_size"
    t.index ["key_hash"], name: "index_solid_cache_entries_on_key_hash", unique: true
  end

  create_table "solid_queue_blocked_executions", force: :cascade do |t|
    t.string "concurrency_key", null: false
    t.datetime "created_at", null: false
    t.datetime "expires_at", null: false
    t.bigint "job_id", null: false
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.index ["concurrency_key", "priority", "job_id"], name: "index_solid_queue_blocked_executions_for_release"
    t.index ["expires_at", "concurrency_key"], name: "index_solid_queue_blocked_executions_for_maintenance"
    t.index ["job_id"], name: "index_solid_queue_blocked_executions_on_job_id", unique: true
  end

  create_table "solid_queue_claimed_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.bigint "process_id"
    t.index ["job_id"], name: "index_solid_queue_claimed_executions_on_job_id", unique: true
    t.index ["process_id", "job_id"], name: "index_solid_queue_claimed_executions_on_process_id_and_job_id"
  end

  create_table "solid_queue_failed_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "error"
    t.bigint "job_id", null: false
    t.index ["job_id"], name: "index_solid_queue_failed_executions_on_job_id", unique: true
  end

  create_table "solid_queue_jobs", force: :cascade do |t|
    t.string "active_job_id"
    t.text "arguments"
    t.string "class_name", null: false
    t.string "concurrency_key"
    t.datetime "created_at", null: false
    t.datetime "finished_at"
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.datetime "scheduled_at"
    t.datetime "updated_at", null: false
    t.index ["active_job_id"], name: "index_solid_queue_jobs_on_active_job_id"
    t.index ["class_name"], name: "index_solid_queue_jobs_on_class_name"
    t.index ["finished_at"], name: "index_solid_queue_jobs_on_finished_at"
    t.index ["queue_name", "finished_at"], name: "index_solid_queue_jobs_for_filtering"
    t.index ["scheduled_at", "finished_at"], name: "index_solid_queue_jobs_for_alerting"
  end

  create_table "solid_queue_pauses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "queue_name", null: false
    t.index ["queue_name"], name: "index_solid_queue_pauses_on_queue_name", unique: true
  end

  create_table "solid_queue_processes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "hostname"
    t.string "kind", null: false
    t.datetime "last_heartbeat_at", null: false
    t.text "metadata"
    t.string "name", null: false
    t.integer "pid", null: false
    t.bigint "supervisor_id"
    t.index ["last_heartbeat_at"], name: "index_solid_queue_processes_on_last_heartbeat_at"
    t.index ["name", "supervisor_id"], name: "index_solid_queue_processes_on_name_and_supervisor_id", unique: true
    t.index ["supervisor_id"], name: "index_solid_queue_processes_on_supervisor_id"
  end

  create_table "solid_queue_ready_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.index ["job_id"], name: "index_solid_queue_ready_executions_on_job_id", unique: true
    t.index ["priority", "job_id"], name: "index_solid_queue_poll_all"
    t.index ["queue_name", "priority", "job_id"], name: "index_solid_queue_poll_by_queue"
  end

  create_table "solid_queue_recurring_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.datetime "run_at", null: false
    t.string "task_key", null: false
    t.index ["job_id"], name: "index_solid_queue_recurring_executions_on_job_id", unique: true
    t.index ["task_key", "run_at"], name: "index_solid_queue_recurring_executions_on_task_key_and_run_at", unique: true
  end

  create_table "solid_queue_recurring_tasks", force: :cascade do |t|
    t.text "arguments"
    t.string "class_name"
    t.string "command", limit: 2048
    t.datetime "created_at", null: false
    t.text "description"
    t.string "key", null: false
    t.integer "priority", default: 0
    t.string "queue_name"
    t.string "schedule", null: false
    t.boolean "static", default: true, null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_solid_queue_recurring_tasks_on_key", unique: true
    t.index ["static"], name: "index_solid_queue_recurring_tasks_on_static"
  end

  create_table "solid_queue_scheduled_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.datetime "scheduled_at", null: false
    t.index ["job_id"], name: "index_solid_queue_scheduled_executions_on_job_id", unique: true
    t.index ["scheduled_at", "priority", "job_id"], name: "index_solid_queue_dispatch_all"
  end

  create_table "solid_queue_semaphores", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "expires_at", null: false
    t.string "key", null: false
    t.datetime "updated_at", null: false
    t.integer "value", default: 1, null: false
    t.index ["expires_at"], name: "index_solid_queue_semaphores_on_expires_at"
    t.index ["key", "value"], name: "index_solid_queue_semaphores_on_key_and_value"
    t.index ["key"], name: "index_solid_queue_semaphores_on_key", unique: true
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

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
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
  add_foreign_key "characters", "users"
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
  add_foreign_key "sessions", "users"
  add_foreign_key "solid_queue_blocked_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_claimed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_failed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_ready_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_recurring_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_scheduled_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "subclasses", "classes"
  add_foreign_key "subraces", "races"
end
