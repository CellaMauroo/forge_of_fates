# Deploy no Railway

O Forge of Fates usa Rails 8, PostgreSQL e Solid Stack. A configuração deste repositório usa um único serviço PostgreSQL gerenciado pelo Railway e executa o Solid Queue dentro do Puma.

## Importar o repositório

1. No Railway, crie um projeto e escolha **Deploy from GitHub repo**.
2. Conecte sua conta GitHub, selecione `CellaMauroo/forge_of_fates` e use a branch que será publicada (normalmente `main`).
3. O Railway detecta automaticamente o `Dockerfile` na raiz e usa o `railway.json` para executar as migrações antes de cada deploy e validar `/up`.
4. No canvas do projeto, adicione um banco **PostgreSQL**. Nomeie-o `Postgres` para usar a referência de variável abaixo sem alterações.

## Variáveis do serviço web

No serviço da aplicação, abra **Variables** e use o Raw Editor:

```dotenv
RAILS_ENV=production
RAILS_LOG_LEVEL=info
RAILS_MAX_THREADS=5
WEB_CONCURRENCY=1
SOLID_QUEUE_IN_PUMA=true
DATABASE_URL=${{Postgres.DATABASE_URL}}
SECRET_KEY_BASE=gere_uma_vez_com_bin/rails_secret
```

Gere `SECRET_KEY_BASE` uma única vez com `bin/rails secret`, copie o valor para o Railway e mantenha-o entre os deploys. Ele é um segredo, não deve ser versionado nem trocado a cada deploy. O `DATABASE_URL` deve ser uma referência ao serviço Postgres, não uma URL copiada manualmente.

## Finalizar

1. Faça o primeiro deploy pelo Railway.
2. Em **Settings → Networking**, gere um domínio público.
3. Confira os logs: o comando `bundle exec rails db:prepare` deve concluir antes do Puma iniciar.
4. Acesse `https://seu-dominio/up`; a resposta deve ser `200`.

Após a integração, cada push na branch configurada no serviço dispara um novo deploy automático. Para produção, conecte o serviço à `main` depois do merge do pull request.
