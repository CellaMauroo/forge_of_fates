class CharactersController < ApplicationController
  def index
    session.delete(:character_wizard)
    @characters = character_scope.recently_updated
  end

  def show
    @character = character_scope.find(params[:id])
  end

  def edit_spells
    @character = character_scope.find(params[:id])
    load_spell_editor
  end

  def update_spells
    @character = character_scope.find(params[:id])
    updater = Characters::SpellSelectionUpdater.new(@character, spell_selection_params)

    if updater.valid?
      updater.save!
      redirect_to character_path(@character), notice: "Magias atualizadas com sucesso."
    else
      load_spell_editor
      flash.now[:alert] = updater.errors.first
      render :edit_spells, status: :unprocessable_entity
    end
  end

  def hit_points
    @character = character_scope.find(params[:id])
    @character.update!(hp_current: params.require(:hp_current).to_i.clamp(0, @character.maximum_hit_points))
    render json: { hp_current: @character.hp_current, hp_maximum: @character.maximum_hit_points }
  end

  def spell_slot
    @character = character_scope.find(params[:id])
    pool = params.require(:pool).to_s
    level = params.require(:level).to_s
    slot = params.require(:slot).to_s
    available = @character.spell_slot_pools.dig(pool, level.to_i).to_i
    return render(json: { error: "Espaço de magia inválido." }, status: :unprocessable_entity) unless Characters::Spellcasting::POOLS.include?(pool) && slot.to_i.between?(0, available - 1)

    state = @character.spell_slots_state.deep_dup
    state[pool] ||= {}
    state[pool][level] ||= {}
    state[pool][level][slot] = !ActiveModel::Type::Boolean.new.cast(state[pool][level][slot])
    @character.update!(spell_slots_state: state)
    render json: { spent: state[pool][level][slot] }
  end

  def create
    @character = current_user.characters.build(character_params)

    if @character.save
      redirect_to @character, notice: "Personagem criado com sucesso."
    else
      redirect_to characters_path, alert: "Não foi possível criar o personagem."
    end
  end

  private
    def character_scope
      current_user.characters.includes(
        :race,
        :subrace,
        :character_spells,
        { character_spells: :spell },
        :background,
        { character_classes: :dnd_class },
        { character_proficiencies: :proficiency }
      )
    end

    def load_spell_editor
      @spellcasting = Characters::Spellcasting.new(@character)
      @spell_classes = @spellcasting.class_choices
      @spells = @spellcasting.available_spells.order(:level, :name).select do |spell|
        @spell_classes.any? { |choice| @spellcasting.allowed_for?(spell, choice[:klass]) }
      end
      @spell_limits = @spell_classes.to_h do |choice|
        [ choice[:klass].id.to_s, @spellcasting.selection_limits_for(choice[:klass]) ]
      end
    end

    def spell_selection_params
      params.fetch(:character, {}).fetch(:spell_selections, {}).values.filter_map do |selection|
        next unless ActiveModel::Type::Boolean.new.cast(selection[:selected])

        selection.permit(:spell_id, :source_class_id).to_h
      end
    end

    def character_params
      params.require(:character).permit(
        :player_name, :character_name, :experience_points, :race_id, :subrace_id,
        :background_id, :alignment, :str_base, :dex_base, :con_base, :int_base,
        :wis_base, :cha_base, :hp_current, :hp_temp, :personality_traits, :ideals,
        :bonds, :flaws, :lore
      )
    end
end
