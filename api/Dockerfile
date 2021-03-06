FROM elixir:1.11.3-alpine AS build

# install build dependencies
# RUN apk add --no-cache build-base npm git python

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix do deps.get, deps.compile
# build assets
COPY assets/package.json assets/package-lock.json ./assets/
RUN apt-get install curl -y
RUN curl -sL https://deb.nodesource.com/setup_lts.x | bash -
RUN apt-get install -y nodejs
RUN npm --prefix ./assets ci --progress=false --no-audit --loglevel=error

COPY priv priv
COPY assets assets
RUN npm run --prefix ./assets deploy
RUN mix phx.digest
# compile and build release
COPY lib lib
# uncomment COPY if rel/ exists
# COPY rel rel
RUN mix do compile, release

# prepare release image
FROM elixir:1.11.3-alpine AS app
# RUN apk add --no-cache openssl ncurses-libs
ENV DATABASE_URL=$DATABASE_URL
ENV SECRET_KEY_BASE=$SECRET_KEY_BASE

WORKDIR /app

RUN chown nobody:nogroup /app

USER nobody:nogroup

COPY --from=build --chown=nobody:nogroup /app/_build/prod/rel/suum ./
ENV HOME=/app
CMD ["bin/suum", "start"]