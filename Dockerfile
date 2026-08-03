ARG RUBY_VERSION=3.3.6

FROM ruby:${RUBY_VERSION}-slim AS base

WORKDIR /rails

ENV RAILS_ENV=production \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT=development:test

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y libpq5 libvips42 && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

FROM base AS build

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libpq-dev pkg-config && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf /usr/local/bundle/cache /usr/local/bundle/ruby/*/cache

COPY . .
RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

FROM base AS production

COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

RUN groupadd --system --gid 1000 rails && \
    useradd --system --uid 1000 --gid 1000 --create-home --shell /bin/bash rails && \
    chmod +x bin/docker-entrypoint && \
    chown -R rails:rails /rails

USER rails

EXPOSE 3000

ENTRYPOINT ["./bin/docker-entrypoint"]
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
