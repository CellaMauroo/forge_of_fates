require "test_helper"

class Characters::SpellcastingTest < ActiveSupport::TestCase
  setup do
    %w[CHA WIS INT STR DEX CON].each do |code|
      Ability.find_or_create_by!(code: code) { |ability| ability.name = code }
    end

    @bard = build_class("Bardo de teste", "CHA", "full", "known")
    @paladin = build_class("Paladino de teste", "CHA", "half", "ability_limited")
    @wizard = build_class("Mago de teste", "INT", "full", "ability_limited")
    @warlock = build_class("Bruxo de teste", "CHA", "pact", "known")
    @fighter = build_class("Guerreiro de teste", "STR", "none", "none")

    progression(@bard, 3, cantrips: 2, spells: 6, highest: 2, slots: { 1 => 4, 2 => 2 })
    progression(@paladin, 2, spells: 1, highest: 1, slots: { 1 => 2 })
    progression(@paladin, 3, spells: 1, highest: 1, slots: { 1 => 3 })
    progression(@paladin, 5, spells: 2, highest: 2, slots: { 1 => 4, 2 => 2 })
    progression(@wizard, 3, cantrips: 3, spells: 3, highest: 2, slots: { 1 => 4, 2 => 2 })
    progression(@warlock, 11, cantrips: 4, spells: 11, highest: 5, pact_level: 5, pact_count: 3, arcanum: [ 6 ])
    MulticlassSpellSlot.find_or_create_by!(combined_caster_level: 4).update!(slot_lvl_1: 4, slot_lvl_2: 3)
  end

  test "prepared casters use the progression base plus their spellcasting ability modifier" do
    paladin = spellcasting_for(@paladin, 5, cha: 14)
    wizard = spellcasting_for(@wizard, 3, int: 16)

    assert_equal 4, paladin.selection_limit_for(@paladin, cantrip: false)
    assert_equal 6, wizard.selection_limit_for(@wizard, cantrip: false)
  end

  test "single half casters use their class slot table instead of the multiclass table" do
    spellcasting = spellcasting_for(@paladin, 3, cha: 14)

    assert_equal({ 1 => 3 }, spellcasting.slot_pools.fetch("spellcasting"))
  end

  test "full and half casters use the official multiclass contribution when both have spellcasting" do
    character = Character.new(character_name: "Aria", cha_base: 14)
    character.character_classes.build(dnd_class: @bard, class_level: 3)
    character.character_classes.build(dnd_class: @paladin, class_level: 3)

    assert_equal({ 1 => 4, 2 => 3 }, Characters::Spellcasting.new(character).slot_pools.fetch("spellcasting"))
  end

  test "pact magic remains separate and unavailable mystic arcanum spells are not selectable" do
    spell = Spell.create!(name: "Arcana de teste", slug: "arcana-de-teste", level: 6, school: "Evocação")
    ClassSpell.create!(dnd_class: @warlock, spell: spell)
    spellcasting = spellcasting_for(@warlock, 11, cha: 14)

    assert_equal({ 5 => 3 }, spellcasting.slot_pools.fetch("pact_magic"))
    assert_not spellcasting.slot_pools.key?("mystic_arcanum")
    assert_not spellcasting.allowed_for?(spell, @warlock)
  end

  test "classes without spellcasting do not offer a spell pool" do
    character = Character.new(character_name: "Kara")
    character.character_classes.build(dnd_class: @fighter, class_level: 20)

    assert_empty Characters::Spellcasting.new(character).class_choices
  end

  test "the backend rejects a spell with an invalid source class" do
    spell = Spell.create!(name: "Origem inválida", slug: "origem-invalida", level: 1, school: "Evocação")
    ClassSpell.create!(dnd_class: @bard, spell: spell)
    character = character_for(@bard, 3, cha: 14)

    updater = Characters::SpellSelectionUpdater.new(character, [ { spell_id: spell.id, source_class_id: @fighter.id } ])

    assert_not updater.valid?
    assert_includes updater.errors, "A classe de origem de uma magia é inválida."
  end

  test "the backend rejects selections above a class spell limit" do
    character = character_for(@bard, 3, cha: 14)
    selections = 7.times.map do |index|
      spell = Spell.create!(name: "Limite #{index}", slug: "limite-#{index}", level: 1, school: "Evocação")
      ClassSpell.create!(dnd_class: @bard, spell: spell)
      { spell_id: spell.id, source_class_id: @bard.id }
    end

    updater = Characters::SpellSelectionUpdater.new(character, selections)

    assert_not updater.valid?
    assert_includes updater.errors, "O limite de magias de #{@bard.name} foi excedido."
  end

  private

    def build_class(name, ability, type, mode)
      DndClass.create!(name: name, primary_ability: ability, hit_die: 8, spellcasting_type: type, spell_selection_mode: mode)
    end

    def progression(klass, level, cantrips: 0, spells: 0, highest: 0, slots: {}, pact_level: 0, pact_count: 0, arcanum: [])
      klass.spellcasting_progressions.create!(
        class_level: level,
        cantrip_limit: cantrips,
        spell_limit: spells,
        highest_spell_level: highest,
        spell_slots: slots,
        pact_slot_level: pact_level,
        pact_slot_count: pact_count,
        mystic_arcanum_levels: arcanum
      )
    end

    def spellcasting_for(klass, level, cha: 8, int: 8)
      Characters::Spellcasting.new(character_for(klass, level, cha: cha, int: int))
    end

    def character_for(klass, level, cha: 8, int: 8)
      Character.new(character_name: "Kara", cha_base: cha, int_base: int).tap do |character|
        character.character_classes.build(dnd_class: klass, class_level: level)
      end
    end
end
