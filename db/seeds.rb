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

spell_selection_modes = {
  "Bardo" => "known", "Bruxo" => "known", "Feiticeiro" => "known", "Patrulheiro" => "known",
  "Mago" => "ability_limited", "Clérigo" => "ability_limited", "Druida" => "ability_limited", "Paladino" => "ability_limited"
}
spell_selection_modes.each { |name, mode| DndClass.find_by!(name: name).update!(spell_selection_mode: mode) }

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
  slug = attributes[:name].parameterize
  spell = Spell.find_by(slug: slug) || Spell.find_by(name: attributes[:name]) || Spell.new
  spell.update!(attributes.merge(slug: slug, source_book: "phb_2014"))
end

# Catálogo integral das listas de classe do Livro do Jogador 2014. As 30 magias
# acima conservam metadados de interface já revisados; para as demais, o seed
# cria o registro canônico e uma sinopse neutra, sem reproduzir texto do livro.
require_relative "seeds/player_handbook_2014_spell_lists"
require_relative "seeds/player_handbook_2014_spell_metadata"

canonical_aliases = {
  "Mão Mágica" => "Mãos Mágicas", "Míssil Mágico" => "Mísseis Mágicos",
  "Explosão Mística" => "Rajada Mística", "Armadura de Mago" => "Armadura Arcana",
  "Escudo" => "Escudo Arcano", "Imagem Espelhada" => "Reflexos", "Animar mortos" => "Animar Mortos",
  "Rogar maldição" => "Rogar Maldição", "Escrita ilusória" => "Escrita Ilusória"
}
canonical_aliases.each do |old_name, new_name|
  old_spell = Spell.find_by(name: old_name)
  next unless old_spell

  canonical_spell = Spell.where.not(id: old_spell.id).find_by(name: new_name)
  if canonical_spell
    CharacterSpell.where(spell_id: old_spell.id).find_each do |selection|
      existing = CharacterSpell.find_by(character_id: selection.character_id, spell_id: canonical_spell.id)
      existing ? selection.destroy! : selection.update_column(:spell_id, canonical_spell.id)
    end
    ClassSpell.where(spell_id: old_spell.id).find_each do |class_spell|
      ClassSpell.find_or_create_by!(class_id: class_spell.class_id, spell_id: canonical_spell.id)
      class_spell.destroy!
    end
    old_spell.destroy!
  else
    old_spell.update!(name: new_name, slug: new_name.parameterize)
  end
end

school_names = {
  "abjuração" => "Abjuração", "adivinhação" => "Adivinhação", "conjuração" => "Conjuração",
  "encantamento" => "Encantamento", "encantmento" => "Encantamento", "evocação" => "Evocação",
  "ilusão" => "Ilusão", "necromancia" => "Necromancia", "transmutação" => "Transmutação",
  "transmutaçõ" => "Transmutação", "bjuração" => "Abjuração"
}

PlayerHandbook2014SpellLists.by_class.each do |class_name, entries|
  klass = DndClass.find_by!(name: class_name)
  entries.each do |level, name, school, ritual|
    spell = Spell.find_by(name: name) || Spell.find_by(slug: name.parameterize) || Spell.new
    metadata = PlayerHandbook2014SpellMetadata.for(name)
    spell.update!(
      name: name, slug: name.parameterize, level: level, school: school_names.fetch(school, school.to_s.titleize),
      is_ritual: ritual, source_book: "phb_2014",
      casting_time: metadata&.fetch(0) || spell.casting_time.presence || "Consulte o Livro do Jogador",
      range_text: metadata&.fetch(1) || spell.range_text.presence || "Consulte o Livro do Jogador",
      duration: metadata&.fetch(2) || spell.duration.presence || "Consulte o Livro do Jogador",
      description: spell.description.presence || "Magia do Livro do Jogador 2014. Consulte o mestre para os efeitos completos."
    )
    ClassSpell.find_or_create_by!(dnd_class: klass, spell: spell)
  end
end

# Relações de lista para o catálogo inicial. As magias são associadas somente às
# classes que as possuem no Livro do Jogador; o backend jamais aceita uma magia
# fora desta relação.
class_spell_names = {
  "Bardo" => [ "Luz", "Prestidigitação", "Curar Ferimentos", "Detectar Magia", "Enfeitiçar Pessoa", "Onda Trovejante", "Sono", "Imobilizar Pessoa", "Invisibilidade", "Padrão Hipnótico", "Dissipar Magia" ],
  "Bruxo" => [ "Prestidigitação", "Explosão Mística", "Enfeitiçar Pessoa", "Escudo", "Sono", "Imobilizar Pessoa", "Invisibilidade", "Passo Nebuloso", "Dissipar Magia", "Padrão Hipnótico" ],
  "Clérigo" => [ "Chama Sagrada", "Luz", "Orientação", "Curar Ferimentos", "Detectar Magia", "Arma Espiritual", "Imobilizar Pessoa", "Dissipar Magia" ],
  "Druida" => [ "Orientação", "Curar Ferimentos", "Detectar Magia", "Enfeitiçar Pessoa", "Onda Trovejante", "Imobilizar Pessoa", "Dissipar Magia" ],
  "Feiticeiro" => [ "Raio de Fogo", "Luz", "Prestidigitação", "Toque Chocante", "Escudo", "Sono", "Mãos Flamejantes", "Enfeitiçar Pessoa", "Míssil Mágico", "Imobilizar Pessoa", "Invisibilidade", "Passo Nebuloso", "Raio Ardente", "Teia", "Bola de Fogo", "Contramágica", "Dissipar Magia", "Relâmpago", "Voar" ],
  "Mago" => [ "Raio de Fogo", "Luz", "Prestidigitação", "Toque Chocante", "Escudo", "Sono", "Mãos Flamejantes", "Enfeitiçar Pessoa", "Míssil Mágico", "Imobilizar Pessoa", "Invisibilidade", "Passo Nebuloso", "Raio Ardente", "Teia", "Bola de Fogo", "Contramágica", "Dissipar Magia", "Relâmpago", "Voar", "Armadura de Mago" ],
  "Paladino" => [ "Curar Ferimentos", "Detectar Magia", "Escudo", "Imobilizar Pessoa", "Dissipar Magia" ],
  "Patrulheiro" => [ "Curar Ferimentos", "Detectar Magia", "Passos Longos", "Teia", "Dissipar Magia" ]
}
class_spell_names.each do |class_name, names|
  klass = DndClass.find_by!(name: class_name)
  Spell.where(name: names).find_each { |spell| ClassSpell.find_or_create_by!(dnd_class: klass, spell: spell) }
end

# Tabelas 2014 de níveis: truques, magias escolhidas/preparadas e espaços.
# Para conjuradores preparados, spell_limit guarda somente a parcela gerada pelo
# nível; Characters::Spellcasting soma o modificador da habilidade apropriada.
known_spells = {
  "Bardo" => [ 4, 5, 6, 7, 8, 9, 10, 11, 12, 14, 15, 15, 16, 18, 19, 19, 20, 22, 22, 22 ],
  "Feiticeiro" => [ 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 12, 13, 13, 14, 14, 15, 15, 15, 15 ],
  "Bruxo" => [ 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 11, 11, 12, 12, 13, 13, 14, 14, 15, 15 ],
  "Patrulheiro" => [ 0, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 11, 11 ]
}

prepared_spell_bases = {
  "Clérigo" => (1..20).to_a,
  "Druida" => (1..20).to_a,
  "Mago" => (1..20).to_a,
  "Paladino" => (1..20).map { |level| level / 2 }
}
cantrips = {
  "Bardo" => [ 2, 2, 2, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4 ],
  "Clérigo" => [ 3, 3, 3, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5 ],
  "Druida" => [ 2, 2, 2, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4 ],
  "Feiticeiro" => [ 4, 4, 4, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6 ],
  "Bruxo" => [ 2, 2, 2, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4 ],
  "Mago" => [ 3, 3, 3, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5 ]
}
# A tabela de conjurador completo também é a tabela oficial de multiclasse.
full_caster_slots = [
  [], [ 2 ], [ 3 ], [ 4, 2 ], [ 4, 3 ], [ 4, 3, 2 ], [ 4, 3, 3 ], [ 4, 3, 3, 1 ], [ 4, 3, 3, 2 ], [ 4, 3, 3, 3, 1 ],
  [ 4, 3, 3, 3, 2 ], [ 4, 3, 3, 3, 2, 1 ], [ 4, 3, 3, 3, 2, 1 ], [ 4, 3, 3, 3, 2, 1, 1 ], [ 4, 3, 3, 3, 2, 1, 1 ],
  [ 4, 3, 3, 3, 2, 1, 1, 1 ], [ 4, 3, 3, 3, 2, 1, 1, 1 ], [ 4, 3, 3, 3, 3, 1, 1, 1, 1 ], [ 4, 3, 3, 3, 3, 1, 1, 1, 1 ],
  [ 4, 3, 3, 3, 3, 2, 1, 1, 1 ], [ 4, 3, 3, 3, 3, 2, 2, 1, 1 ]
]
half_caster_slots = [
  [], [], [ 2 ], [ 3 ], [ 3 ], [ 4, 2 ], [ 4, 2 ], [ 4, 3 ], [ 4, 3 ], [ 4, 3, 2 ],
  [ 4, 3, 2 ], [ 4, 3, 3 ], [ 4, 3, 3 ], [ 4, 3, 3, 1 ], [ 4, 3, 3, 1 ],
  [ 4, 3, 3, 2 ], [ 4, 3, 3, 2 ], [ 4, 3, 3, 3, 1 ], [ 4, 3, 3, 3, 1 ],
  [ 4, 3, 3, 3, 2 ], [ 4, 3, 3, 3, 2 ]
]
slot_hash = ->(slots) { slots.each_with_index.each_with_object({}) { |(count, index), values| values[index + 1] = count if count.positive? } }
pact_slots = [ [ 1, 1 ], [ 1, 2 ], [ 2, 2 ], [ 2, 2 ], [ 3, 2 ], [ 3, 2 ], [ 4, 2 ], [ 4, 2 ], [ 5, 2 ], [ 5, 2 ], [ 5, 3 ], [ 5, 3 ], [ 5, 3 ], [ 5, 3 ], [ 5, 3 ], [ 5, 3 ], [ 5, 4 ], [ 5, 4 ], [ 5, 4 ], [ 5, 4 ] ]

DndClass.where(name: spell_selection_modes.keys).find_each do |klass|
  (1..20).each do |level|
    pact_level, pact_count = klass.spellcasting_type == "pact" ? pact_slots[level - 1] : [ 0, 0 ]
    arcanum = klass.spellcasting_type == "pact" ? [ [ 11, 6 ], [ 13, 7 ], [ 15, 8 ], [ 17, 9 ] ].filter_map { |minimum, circle| circle if level >= minimum } : []
    slots = case klass.spellcasting_type
    when "full" then slot_hash.call(full_caster_slots[level])
    when "half" then slot_hash.call(half_caster_slots[level])
    else {}
    end
    progression = klass.spellcasting_progressions.find_or_initialize_by(class_level: level)
    spell_limit = known_spells.fetch(klass.name) { prepared_spell_bases.fetch(klass.name, Array.new(20, 0)) }[level - 1]
    progression.update!(
      cantrip_limit: cantrips.fetch(klass.name, Array.new(20, 0))[level - 1],
      spell_limit: spell_limit,
      highest_spell_level: klass.spellcasting_type == "pact" ? pact_level : slots.keys.max.to_i,
      spell_slots: slots, pact_slot_level: pact_level, pact_slot_count: pact_count, mystic_arcanum_levels: arcanum
    )
  end
end

# Tabela de espaços de magia compartilhada por conjuradores completos e
# multiclasses (PHB 2014, p. 165). Paladino e Patrulheiro entram nela pela
# metade do nível; Bruxo usa a reserva Pact Magic acima.
full_caster_slots.each_with_index do |slots, index|
  next if index.zero?

  attributes = (1..9).index_with { |circle| slots[circle - 1].to_i }
  MulticlassSpellSlot.find_or_initialize_by(combined_caster_level: index).update!(attributes.transform_keys { |circle| "slot_lvl_#{circle}" })
end

# Ao criar personagens de demonstração neste arquivo, use sempre a associação
# abaixo para que eles pertençam à conta administrativa:
# admin.characters.find_or_create_by!(character_name: "Nome do personagem") do |character|
#   character.assign_attributes(...)
# end
