# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

admin_email = "admin@forge-of-fates.local"
admin_password = "password"

admin = User.find_or_create_by!(email_address: admin_email) do |user|
  user.password = admin_password
end

# Catálogos fundamentais usados por raças, classes e requisitos do wizard.
abilities = {
  "STR" => "Força",
  "DEX" => "Destreza",
  "CON" => "Constituição",
  "INT" => "Inteligência",
  "WIS" => "Sabedoria",
  "CHA" => "Carisma"
}

abilities.each do |code, name|
  Ability.find_or_initialize_by(code: code).update!(name: name)
end

# Raças básicas do Livro do Jogador (D&D 5e). As descrições foram resumidas
# para a interface do Forge of Fates e os deslocamentos estão em metros.
races = [
  { name: "Anão", speed_meters: 7.5, size: "Médio", description: "Robustos e resilientes, conhecidos por sua tradição, coragem e habilidade com pedra e metal.", bonuses: { "CON" => 2 } },
  { name: "Draconato", speed_meters: 9, size: "Médio", description: "Descendentes orgulhosos de dragões, com herança dracônica e presença imponente.", bonuses: { "STR" => 2, "CHA" => 1 } },
  { name: "Elfo", speed_meters: 9, size: "Médio", description: "Graciosos e longevos, os elfos carregam sentidos aguçados e uma afinidade natural com o extraordinário.", bonuses: { "DEX" => 2 } },
  { name: "Gnomo", speed_meters: 7.5, size: "Pequeno", description: "Inventivos e curiosos, os gnomos combinam inteligência, energia e uma profunda ligação com a magia.", bonuses: { "INT" => 2 } },
  { name: "Halfling", speed_meters: 7.5, size: "Pequeno", description: "Pequenos, ágeis e corajosos, os halflings prosperam graças à sorte e à determinação.", bonuses: { "DEX" => 2 } },
  { name: "Humano", speed_meters: 9, size: "Médio", description: "Versáteis e ambiciosos, os humanos encontram espaço para se destacar em qualquer vocação.", bonuses: { "STR" => 1, "DEX" => 1, "CON" => 1, "INT" => 1, "WIS" => 1, "CHA" => 1 } },
  { name: "Meio-Elfo", speed_meters: 9, size: "Médio", description: "Diplomáticos e adaptáveis, os meio-elfos transitam entre dois mundos e unem diferentes heranças.", bonuses: { "CHA" => 2 } },
  { name: "Meio-Orc", speed_meters: 9, size: "Médio", description: "Fortes e resistentes, os meio-orcs são marcados por determinação, vigor e uma presença intimidadora.", bonuses: { "STR" => 2, "CON" => 1 } },
  { name: "Tiefling", speed_meters: 9, size: "Médio", description: "Marcados por herança infernal, os tieflings carregam carisma, resistência e poder arcano latente.", bonuses: { "INT" => 1, "CHA" => 2 } }
]

races.each do |attributes|
  bonuses = attributes.delete(:bonuses)
  race = Race.find_or_initialize_by(name: attributes[:name])
  race.update!(attributes)

  bonuses.each do |ability_code, bonus_value|
    RaceAbilityBonus.find_or_initialize_by(race: race, ability_code: ability_code, subrace_id: nil).update!(bonus_value: bonus_value, is_choice: false)
  end
end

# Classes básicas do Livro do Jogador (D&D 5e). O tipo de conjuração é usado
# pelo wizard para distinguir combatentes marciais de classes conjuradoras.
classes = [
  { name: "Bárbaro", hit_die: 12, primary_ability: "STR", spellcasting_type: "none" },
  { name: "Bardo", hit_die: 8, primary_ability: "CHA", spellcasting_type: "full" },
  { name: "Bruxo", hit_die: 8, primary_ability: "CHA", spellcasting_type: "pact" },
  { name: "Clérigo", hit_die: 8, primary_ability: "WIS", spellcasting_type: "full" },
  { name: "Druida", hit_die: 8, primary_ability: "WIS", spellcasting_type: "full" },
  { name: "Feiticeiro", hit_die: 6, primary_ability: "CHA", spellcasting_type: "full" },
  { name: "Guerreiro", hit_die: 10, primary_ability: "STR", spellcasting_type: "none" },
  { name: "Ladino", hit_die: 8, primary_ability: "DEX", spellcasting_type: "none" },
  { name: "Mago", hit_die: 6, primary_ability: "INT", spellcasting_type: "full" },
  { name: "Monge", hit_die: 8, primary_ability: "DEX", spellcasting_type: "none" },
  { name: "Paladino", hit_die: 10, primary_ability: "STR", spellcasting_type: "half" },
  { name: "Patrulheiro", hit_die: 10, primary_ability: "DEX", spellcasting_type: "half" }
]

classes.each do |attributes|
  DndClass.find_or_initialize_by(name: attributes[:name]).update!(attributes)
end

backgrounds = [
  {
    name: "Acólito",
    feature_name: "Abrigo dos Fiéis",
    feature_description: "Serviu em um templo, ganhando profundo conhecimento religioso."
  },
  {
    name: "Criminoso",
    feature_name: "Contato Criminoso",
    feature_description: "Vida nas sombras do submundo, com contatos ilícitos valiosos."
  },
  {
    name: "Herói do Povo",
    feature_name: "Hospitalidade Rústica",
    feature_description: "Defensor da comunidade, amado pelos camponeses locais."
  },
  {
    name: "Nobre",
    feature_name: "Posição de Privilégio",
    feature_description: "Nascido em linhagem aristocrática com privilégios e deveres."
  },
  {
    name: "Sábio",
    feature_name: "Pesquisador",
    feature_description: "Dedicou a vida ao estudo em grandes bibliotecas e academias."
  },
  {
    name: "Soldado",
    feature_name: "Patente Militar",
    feature_description: "Veterano de guerra endurecido pela batalha e disciplinado."
  }
]

backgrounds.each do |attributes|
  Background.find_or_initialize_by(name: attributes[:name]).update!(attributes)
end

# Magias do SRD 5.1 / Regras Básicas. As descrições abaixo são resumos originais
# para a interface; os dados de conjuração seguem o material oficial aberto.
spells = [
  { name: "Raio de Fogo", level: 0, school: "Evocação", casting_time: "1 ação", range_text: "120 pés", components: "V, S", duration: "Instantânea", is_ritual: false, description: "Dispara uma centelha flamejante que causa dano de fogo ao alvo." },
  { name: "Mão Mágica", level: 0, school: "Conjuração", casting_time: "1 ação", range_text: "30 pés", components: "V, S", duration: "1 minuto", is_ritual: false, description: "Cria uma mão espectral capaz de manipular pequenos objetos à distância." },
  { name: "Luz", level: 0, school: "Evocação", casting_time: "1 ação", range_text: "Toque", components: "V, M", duration: "1 hora", is_ritual: false, description: "Faz um objeto brilhar e iluminar a área ao redor." },
  { name: "Prestidigitação", level: 0, school: "Transmutação", casting_time: "1 ação", range_text: "10 pés", components: "V, S", duration: "Até 1 hora", is_ritual: false, description: "Produz pequenos efeitos mágicos utilitários e inofensivos." },
  { name: "Explosão Mística", level: 0, school: "Evocação", casting_time: "1 ação", range_text: "120 pés", components: "V, S", duration: "Instantânea", is_ritual: false, description: "Lança energia arcana contra uma criatura dentro do alcance." },
  { name: "Chama Sagrada", level: 0, school: "Evocação", casting_time: "1 ação", range_text: "60 pés", components: "V, S", duration: "Instantânea", is_ritual: false, description: "Uma chama radiante desce sobre o alvo, que tenta evitar o efeito." },
  { name: "Orientação", level: 0, school: "Adivinhação", casting_time: "1 ação", range_text: "Toque", components: "V, S", duration: "Concentração, até 1 minuto", is_ritual: false, description: "Concede uma breve ajuda divina a um teste de habilidade." },
  { name: "Toque Chocante", level: 0, school: "Evocação", casting_time: "1 ação", range_text: "Toque", components: "V, S", duration: "Instantânea", is_ritual: false, description: "Um choque elétrico atinge uma criatura adjacente." },
  { name: "Míssil Mágico", level: 1, school: "Evocação", casting_time: "1 ação", range_text: "120 pés", components: "V, S", duration: "Instantânea", is_ritual: false, description: "Projeta dardos de força que acertam seus alvos de forma confiável." },
  { name: "Escudo", level: 1, school: "Abjuração", casting_time: "1 reação", range_text: "Pessoal", components: "V, S", duration: "1 rodada", is_ritual: false, description: "Ergue uma barreira invisível que protege contra um ataque e aumenta a CA." },
  { name: "Sono", level: 1, school: "Encantamento", casting_time: "1 ação", range_text: "90 pés", components: "V, S, M", duration: "1 minuto", is_ritual: false, description: "Coloca criaturas com poucos pontos de vida em sono mágico." },
  { name: "Detectar Magia", level: 1, school: "Adivinhação", casting_time: "1 ação", range_text: "Pessoal", components: "V, S", duration: "Concentração, até 10 minutos", is_ritual: true, description: "Revela a presença de magia e suas auras próximas." },
  { name: "Armadura de Mago", level: 1, school: "Abjuração", casting_time: "1 ação", range_text: "Toque", components: "V, S, M", duration: "8 horas", is_ritual: false, description: "Protege uma criatura sem armadura com uma defesa arcana duradoura." },
  { name: "Curar Ferimentos", level: 1, school: "Evocação", casting_time: "1 ação", range_text: "Toque", components: "V, S", duration: "Instantânea", is_ritual: false, description: "Restaura pontos de vida de uma criatura tocada." },
  { name: "Mãos Flamejantes", level: 1, school: "Evocação", casting_time: "1 ação", range_text: "Pessoal (cone de 15 pés)", components: "V, S", duration: "Instantânea", is_ritual: false, description: "Chamas em cone irrompem de suas mãos e queimam inimigos próximos." },
  { name: "Enfeitiçar Pessoa", level: 1, school: "Encantamento", casting_time: "1 ação", range_text: "30 pés", components: "V, S", duration: "1 hora", is_ritual: false, description: "Torna temporariamente uma criatura humanoide mais receptiva a você." },
  { name: "Onda Trovejante", level: 1, school: "Evocação", casting_time: "1 ação", range_text: "Pessoal (cubo de 15 pés)", components: "V, S", duration: "Instantânea", is_ritual: false, description: "Uma onda sonora empurra criaturas próximas e causa dano trovejante." },
  { name: "Teia", level: 2, school: "Conjuração", casting_time: "1 ação", range_text: "60 pés", components: "V, S, M", duration: "Concentração, até 1 hora", is_ritual: false, description: "Preenche uma área com teias pegajosas que podem restringir criaturas." },
  { name: "Passo Nebuloso", level: 2, school: "Conjuração", casting_time: "1 ação bônus", range_text: "Pessoal", components: "V", duration: "Instantânea", is_ritual: false, description: "Teleporta você para um espaço desocupado que consiga enxergar." },
  { name: "Raio Ardente", level: 2, school: "Evocação", casting_time: "1 ação", range_text: "120 pés", components: "V, S", duration: "Instantânea", is_ritual: false, description: "Dispara vários raios de fogo contra um ou mais alvos." },
  { name: "Imobilizar Pessoa", level: 2, school: "Encantamento", casting_time: "1 ação", range_text: "60 pés", components: "V, S, M", duration: "Concentração, até 1 minuto", is_ritual: false, description: "Pode paralisar temporariamente um humanoide que falhe em resistir." },
  { name: "Invisibilidade", level: 2, school: "Ilusão", casting_time: "1 ação", range_text: "Toque", components: "V, S, M", duration: "Concentração, até 1 hora", is_ritual: false, description: "Torna uma criatura invisível até que a magia termine ou ela ataque." },
  { name: "Imagem Espelhada", level: 2, school: "Ilusão", casting_time: "1 ação", range_text: "Pessoal", components: "V, S", duration: "1 minuto", is_ritual: false, description: "Cria duplicatas ilusórias que confundem ataques contra você." },
  { name: "Arma Espiritual", level: 2, school: "Evocação", casting_time: "1 ação bônus", range_text: "60 pés", components: "V, S", duration: "1 minuto", is_ritual: false, description: "Cria uma arma flutuante que ataca inimigos sob seu comando." },
  { name: "Bola de Fogo", level: 3, school: "Evocação", casting_time: "1 ação", range_text: "150 pés", components: "V, S, M", duration: "Instantânea", is_ritual: false, description: "Uma explosão flamejante atinge criaturas em uma área ampla." },
  { name: "Contramágica", level: 3, school: "Abjuração", casting_time: "1 reação", range_text: "60 pés", components: "S", duration: "Instantânea", is_ritual: false, description: "Interrompe a conjuração de outra criatura quando lançada no momento certo." },
  { name: "Voar", level: 3, school: "Transmutação", casting_time: "1 ação", range_text: "Toque", components: "V, S, M", duration: "Concentração, até 10 minutos", is_ritual: false, description: "Concede deslocamento de voo a uma criatura voluntária." },
  { name: "Relâmpago", level: 3, school: "Evocação", casting_time: "1 ação", range_text: "Pessoal (linha de 100 pés)", components: "V, S, M", duration: "Instantânea", is_ritual: false, description: "Um relâmpago atravessa uma linha à sua frente, causando dano elétrico." },
  { name: "Dissipar Magia", level: 3, school: "Abjuração", casting_time: "1 ação", range_text: "120 pés", components: "V, S", duration: "Instantânea", is_ritual: false, description: "Tenta encerrar um efeito mágico ativo dentro do alcance." },
  { name: "Padrão Hipnótico", level: 3, school: "Ilusão", casting_time: "1 ação", range_text: "120 pés", components: "V, S, M", duration: "Concentração, até 1 minuto", is_ritual: false, description: "Um padrão luminoso fascina criaturas que não conseguem resistir ao efeito." }
]

spells.each do |attributes|
  Spell.find_or_initialize_by(name: attributes[:name]).update!(attributes)
end

# Ao criar personagens de demonstração neste arquivo, use sempre a associação
# abaixo para que eles pertençam à conta administrativa:
# admin.characters.find_or_create_by!(character_name: "Nome do personagem") do |character|
#   character.assign_attributes(...)
# end
