# Convenções do Forge of Fates

## HAML e Tailwind

- Não use a sintaxe abreviada do HAML (`%div.classe`) para classes Tailwind que contenham `/`, `:`, `[` ou `]`. Esses caracteres podem ser interpretados como conteúdo pelo parser HAML e causar `Haml::SyntaxError` ou classes renderizadas como texto.
- Para essas classes, use sempre um atributo explícito: `%div{ class: "bg-slate-950/95 hover:bg-violet-500" }`.
- Nunca misture conteúdo aninhado com atributos condicionais complexos na própria linha de uma tag. Calcule a classe antes, por exemplo: `- card_classes = selected ? "border-amber-500" : "border-slate-800"`, e depois aplique-a por `class: card_classes`.
- Em views do wizard, defina `content_for(:full_width_layout, true)` para impedir que o layout padrão limite a tela a um container estreito.
- Antes de salvar uma view HAML, revise tags com conteúdo aninhado, atributos condicionais e variantes Tailwind para evitar `Illegal nesting`.
