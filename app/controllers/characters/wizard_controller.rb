class Characters::WizardController < ApplicationController
  STEPS = %w[race klass abilities background spells].freeze
  ABILITIES = %w[str dex con int wis cha].freeze
  BACKGROUND_DETAILS = {
    "Acólito" => { skills: "Intuição, Religião", items: [ "Símbolo sagrado", "Livro de orações", "15 PO" ] },
    "Criminoso" => { skills: "Enganação, Furtividade", items: [ "Pé de cabra", "Kit de ladrão", "15 PO" ] },
    "Herói do Povo" => { skills: "Trato de Animais, Sobrevivência", items: [ "Ferramentas artesanais", "Pá de ferro", "10 PO" ] },
    "Nobre" => { skills: "História, Persuasão", items: [ "Roupas finas", "Anel de sinete", "25 PO" ] },
    "Sábio" => { skills: "Arcanismo, História", items: [ "Frasco de tinta", "Pena de escrita", "10 PO" ] },
    "Soldado" => { skills: "Atletismo, Intimidação", items: [ "Insígnia de posto", "Troféu de batalha", "10 PO" ] }
  }.freeze

  before_action :set_step

  def show
    load_collections
    case @step
    when "race" then render :race
    when "klass" then render :klass
    when "abilities" then render :abilities
    when "background" then render :background
    when "spells" then render :spells
    end
  end

  def update
    wizard_data[@step] = step_params
    clear_spell_selection_unless_spellcaster! if @step == "klass"
    session[:character_wizard] = wizard_data

    if @step == "spells"
      clear_spell_selection_unless_spellcaster!
      session[:character_wizard] = wizard_data
      return create_character
    end

    return render_validation_error unless valid_step?

    redirect_to wizard_step_characters_path(next_step)
  end

  def destroy
    session.delete(:character_wizard)
    redirect_to characters_path, notice: "Criação de personagem cancelada."
  end

  private

    def set_step
      @step = params[:step].to_s
      redirect_to(wizard_step_characters_path("race"), alert: "Etapa inválida.") unless STEPS.include?(@step)
    end

    def wizard_data
      session[:character_wizard] ||= {
        "race" => { "name" => "", "race_id" => nil },
        "klass" => { "primary_class_id" => nil, "primary_class_level" => 1, "is_multiclass" => false, "secondary_class_id" => nil, "secondary_class_level" => 1 },
        "abilities" => { "base_attributes" => ABILITIES.index_with { 8 } },
        "background" => { "background_id" => nil },
        "spells" => { "spell_selections" => {} }
      }
    end

    def step_params
      case @step
      when "race"
        params.require(:wizard).permit(:name, :race_id).to_h
      when "klass"
        permitted = params.require(:wizard).permit(:primary_class_id, :primary_class_level, :is_multiclass, :secondary_class_id, :secondary_class_level).to_h
        permitted["is_multiclass"] = ActiveModel::Type::Boolean.new.cast(permitted["is_multiclass"])
        permitted
      when "abilities"
        { "base_attributes" => params.require(:wizard).permit(base_attributes: ABILITIES).fetch(:base_attributes, {}).to_h }
      when "background"
        params.require(:wizard).permit(:background_id).to_h
      when "spells"
        selections = params.require(:wizard).permit(spell_selections: {}).fetch(:spell_selections, {}).to_h
        { "spell_selections" => selections }
      end
    end

    def create_character
      data = wizard_data
      attributes = data.fetch("abilities").fetch("base_attributes").transform_keys { |key| "#{key}_base" }
      character = current_user.characters.build(
        attributes.merge(
          "character_name" => data.dig("race", "name"),
          "race_id" => data.dig("race", "race_id"),
          "background_id" => data.dig("background", "background_id"),
          "experience_points" => 0,
          "hp_temp" => 0
        )
      )
      primary_class = DndClass.find(data.dig("klass", "primary_class_id"))
      character.hp_current = Characters::HpCalculator.new(character, dnd_class: primary_class).calculate

      character.character_classes.build(dnd_class: primary_class, class_level: data.dig("klass", "primary_class_level").to_i, is_primary_class: true)
      if data.dig("klass", "is_multiclass") && data.dig("klass", "secondary_class_id").present?
        character.character_classes.build(dnd_class_id: data.dig("klass", "secondary_class_id"), class_level: data.dig("klass", "secondary_class_level").to_i)
      end

      updater = Characters::SpellSelectionUpdater.new(character, wizard_spell_selections)
      return render_creation_error(updater.errors.first) unless updater.valid?

      Character.transaction do
        character.save!
        updater.save!
      end

      session.delete(:character_wizard)
      redirect_to character_path(character), notice: "Personagem criado com sucesso."
    rescue ActiveRecord::RecordInvalid => error
      render_creation_error(error.record.errors.full_messages.to_sentence.presence || "Não foi possível criar o personagem.")
    rescue ActiveRecord::RecordNotFound
      render_creation_error("Uma das escolhas não está mais disponível. Revise o personagem antes de criar.")
    end

    def next_step
      STEPS[STEPS.index(@step) + 1]
    end

    def valid_step?
      case @step
      when "race"
        wizard_data.dig("race", "name").present? && Race.exists?(id: wizard_data.dig("race", "race_id"))
      when "klass"
        primary = DndClass.exists?(id: wizard_data.dig("klass", "primary_class_id"))
        secondary = !wizard_data.dig("klass", "is_multiclass") || DndClass.exists?(id: wizard_data.dig("klass", "secondary_class_id"))
        primary && secondary
      when "abilities"
        Characters::PointBuyCalculator.new(wizard_data.dig("abilities", "base_attributes")).valid?
      when "background"
        Background.exists?(id: wizard_data.dig("background", "background_id"))
      else
        true
      end
    end

    def render_validation_error
      message = "Preencha todos os campos obrigatórios desta etapa antes de continuar."
      respond_to do |format|
        format.turbo_stream do
          flash.now[:alert] = message
          render turbo_stream: turbo_stream.replace("flash", partial: "shared/flash")
        end
        format.html { redirect_to wizard_step_characters_path(@step), alert: message }
      end
    end

    def load_collections
      @wizard = wizard_data
      @races = Race.order(:name) if @step == "race"
      @classes = DndClass.order(:name) if @step == "klass"
      if @step == "background"
        @backgrounds = Background.order(:name)
        @background_details = BACKGROUND_DETAILS
      end
      if @step == "spells"
        @spellcasting = wizard_spellcasting
        @spell_classes = @spellcasting.class_choices
        @spells = @spellcasting.available_spells.order(:level, :name)
        @spell_limits = @spell_classes.to_h do |choice|
          [ choice[:klass].id.to_s, @spellcasting.selection_limits_for(choice[:klass]) ]
        end
        @can_select_spells = @spell_classes.any?
      end
      if @step == "abilities"
        @race = Race.find_by(id: @wizard.dig("race", "race_id"))
        @racial_bonuses = RaceAbilityBonus.where(race_id: @race).each_with_object({}) do |bonus, values|
          values[bonus.ability_code.downcase] = bonus.bonus_value
        end
      end
    end

    def clear_spell_selection_unless_spellcaster!
      return if spellcasting_available?

      wizard_data["spells"] = { "spell_selections" => {} }
    end

    def spellcasting_available?
      wizard_class_choices.any? do |choice|
        choice[:klass].spellcasting_available_at?(choice[:level])
      end
    end

    def wizard_spellcasting
      @wizard_spellcasting ||= begin
        character = Character.new(wizard_attributes_for_spellcasting)
        wizard_class_choices.each do |choice|
          character.character_classes.build(dnd_class: choice[:klass], class_level: choice[:level].to_i)
        end
        Characters::Spellcasting.new(character)
      end
    end

    def wizard_attributes_for_spellcasting
      attributes = wizard_data.dig("abilities", "base_attributes").to_h
      attributes.transform_keys { |key| "#{key}_base" }
    end

    def wizard_spell_selections
      wizard_data.dig("spells", "spell_selections").to_h.values.filter_map do |selection|
        next unless ActiveModel::Type::Boolean.new.cast(selection["selected"])

        { spell_id: selection["spell_id"], source_class_id: selection["source_class_id"] }
      end
    end

    def render_creation_error(message)
      load_collections
      flash.now[:alert] = message
      render :spells, status: :unprocessable_entity
    end

    def wizard_class_choices
      klass_data = wizard_data.fetch("klass", {})
      choices = [ [ klass_data["primary_class_id"], klass_data["primary_class_level"] ] ]
      if klass_data["is_multiclass"]
        choices << [ klass_data["secondary_class_id"], klass_data["secondary_class_level"] ]
      end

      class_ids = choices.map(&:first).compact_blank
      classes_by_id = DndClass.where(id: class_ids).index_by { |klass| klass.id.to_s }

      choices.filter_map do |class_id, level|
        klass = classes_by_id[class_id.to_s]
        { klass: klass, level: level } if klass
      end
    end
end
