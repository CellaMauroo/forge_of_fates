class Characters::SpellSelectionUpdater
  Selection = Data.define(:spell_id, :source_class_id)

  def initialize(character, selections)
    @character = character
    @selections = Array(selections).filter_map do |selection|
      spell_id = selection[:spell_id] || selection["spell_id"]
      class_id = selection[:source_class_id] || selection["source_class_id"]
      Selection.new(spell_id: spell_id.to_i, source_class_id: class_id.to_i) if spell_id.present? && class_id.present?
    end
    @spellcasting = Characters::Spellcasting.new(character)
  end

  def valid?
    errors.empty?
  end

  def errors
    @errors ||= begin
      result = []
      result << "Há magias repetidas." if @selections.map(&:spell_id).uniq.size != @selections.size
      spells = Spell.where(id: @selections.map(&:spell_id)).index_by(&:id)
      result << "Uma ou mais magias não existem." if spells.size != @selections.size

      @selections.each do |selection|
        spell = spells[selection.spell_id]
        klass = DndClass.find_by(id: selection.source_class_id)
        result << "A classe de origem de uma magia é inválida." unless klass && spell && @spellcasting.allowed_for?(spell, klass)
      end

      @selections.group_by(&:source_class_id).each do |class_id, selections|
        klass = DndClass.find_by(id: class_id)
        next unless klass

        selections.group_by { |selection| @spellcasting.selection_bucket_for(spells[selection.spell_id], klass) }.each do |bucket, class_selections|
          limit = @spellcasting.selection_limit_for(klass, spell: spells[class_selections.first.spell_id])
          next unless class_selections.size > limit

          result << limit_error_for(klass, bucket)
        end
      end
      result.uniq
    end
  end

  def save!
    raise ActiveRecord::RecordInvalid.new(@character) unless valid?

    CharacterSpell.transaction do
      @character.character_spells.where.not(spell_id: @selections.map(&:spell_id)).destroy_all
      @selections.each do |selection|
        record = @character.character_spells.find_or_initialize_by(spell_id: selection.spell_id)
        record.update!(source_class_id: selection.source_class_id, is_prepared: false, is_always_prepared: false)
      end
    end
  end

  private

    def limit_error_for(klass, bucket)
      if bucket == :cantrips
        "O limite de truques de #{klass.name} foi excedido."
      else
        "O limite de magias de #{klass.name} foi excedido."
      end
    end
end
