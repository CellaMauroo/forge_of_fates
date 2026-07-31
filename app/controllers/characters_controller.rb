class CharactersController < ApplicationController
  def index
    session.delete(:character_wizard)
    @characters = character_scope.recently_updated
  end

  def show
    @character = character_scope.find(params[:id])
  end

  def hit_points
    @character = character_scope.find(params[:id])
    @character.update!(hp_current: params.require(:hp_current).to_i.clamp(0, @character.maximum_hit_points))
    render json: { hp_current: @character.hp_current, hp_maximum: @character.maximum_hit_points }
  end

  def spell_slot
    @character = character_scope.find(params[:id])
    level = params.require(:level).to_s
    slot = params.require(:slot).to_s
    state = @character.spell_slots_state.deep_dup
    state[level] ||= {}
    state[level][slot] = !ActiveModel::Type::Boolean.new.cast(state[level][slot])
    @character.update!(spell_slots_state: state)
    render json: { spent: state[level][slot] }
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

    def character_params
      params.require(:character).permit(
        :player_name, :character_name, :experience_points, :race_id, :subrace_id,
        :background_id, :alignment, :str_base, :dex_base, :con_base, :int_base,
        :wis_base, :cha_base, :hp_current, :hp_temp, :personality_traits, :ideals,
        :bonds, :flaws, :lore
      )
    end
end
