# Run after db:seed with: bin/rails runner db/demo_seeds.rb
# Fictional portfolio data. Safe to rerun without duplicating characters.
admin = User.find_by!(email_address: "admin@forge-of-fates.local")

characters = [
  {
    name: "Lyra Moonwhisper", race: "Elfo", background: "Sábio", klass: "Mago", level: 5,
    hp: 27, xp: 6500, abilities: [8, 14, 13, 18, 12, 10],
    alignment: "Caótico e Bom", lore: "Cartógrafa de ruínas arcanas em busca de uma biblioteca perdida.",
    traits: "Curiosa e observadora; anota cada descoberta em seu diário.",
    ideals: "Conhecimento deve ser compartilhado.", bonds: "Protege os mapas deixados por sua mentora.",
    flaws: "Investiga mistérios mesmo quando deveria recuar.",
    spells: ["Raio de Fogo", "Mão Mágica", "Míssil Mágico", "Escudo", "Detectar Magia", "Passo Nebuloso", "Bola de Fogo"]
  },
  {
    name: "Tharok Ironshield", race: "Anão", background: "Soldado", klass: "Guerreiro", level: 4,
    hp: 40, xp: 3000, abilities: [17, 11, 16, 10, 12, 9],
    alignment: "Leal e Bom", lore: "Antigo guardião de uma fortaleza nas montanhas.",
    traits: "Fala pouco e cumpre suas promessas.", ideals: "Coragem é defender quem não pode lutar.",
    bonds: "Carrega o escudo de sua família.", flaws: "Confia demais em planos de batalha.", spells: []
  },
  {
    name: "Seraphine Ember", race: "Tiefling", background: "Herói do Povo", klass: "Bardo", level: 3,
    hp: 24, xp: 900, abilities: [9, 15, 13, 12, 10, 17],
    alignment: "Neutro e Bom", lore: "Viajante que reúne histórias e canções de vilarejos esquecidos.",
    traits: "Encontra um motivo para celebrar mesmo após uma derrota.", ideals: "Toda pessoa merece ouvir sua própria história.",
    bonds: "Prometeu devolver uma relíquia ao seu povo.", flaws: "Aceita desafios sem medir o risco.",
    spells: ["Luz", "Prestidigitação", "Curar Ferimentos", "Enfeitiçar Pessoa"]
  }
]

characters.each do |entry|
  race = Race.find_by!(name: entry.fetch(:race))
  background = Background.find_by!(name: entry.fetch(:background))
  klass = DndClass.find_by!(name: entry.fetch(:klass))
  str, dex, con, int, wis, cha = entry.fetch(:abilities)

  character = admin.characters.find_or_initialize_by(character_name: entry.fetch(:name))
  character.update!(
    player_name: "Portfólio", race: race, background: background,
    alignment: entry.fetch(:alignment), experience_points: entry.fetch(:xp),
    hp_current: entry.fetch(:hp), hp_temp: 0,
    str_base: str, dex_base: dex, con_base: con, int_base: int, wis_base: wis, cha_base: cha,
    lore: entry.fetch(:lore), personality_traits: entry.fetch(:traits),
    ideals: entry.fetch(:ideals), bonds: entry.fetch(:bonds), flaws: entry.fetch(:flaws)
  )

  character.character_classes.find_or_initialize_by(dnd_class: klass).update!(
    class_level: entry.fetch(:level), is_primary_class: true
  )

  entry.fetch(:spells).each do |name|
    spell = Spell.find_by!(name: name)
    character.character_spells.find_or_initialize_by(spell: spell).update!(
      is_prepared: true, source_class: klass
    )
  end
end

puts "Demo ready: #{admin.characters.where(character_name: characters.map { |entry| entry.fetch(:name) }).count} characters for #{admin.email_address}"

