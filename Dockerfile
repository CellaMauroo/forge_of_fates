ARG RUBY_VERSION=3.3.0
FROM ruby:${RUBY_VERSION}-slim

# Instala dependências básicas do sistema
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential \
      libpq-dev \
      git \
      curl \
      nodejs \
      npm && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Define o diretório de trabalho
WORKDIR /rails

# Copia e instala as gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copia todo o código da aplicação (incluindo a pasta bin/)
COPY . .

# Garante permissão de execução para o script de entrypoint do Rails
RUN chmod +x bin/docker-entrypoint

# Define o entrypoint nativo do Rails 8
ENTRYPOINT ["bin/docker-entrypoint"]

EXPOSE 3000

# Executa o servidor Rails por padrão
CMD ["bin/rails", "server", "-b", "0.0.0.0"]