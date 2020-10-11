FROM elixir:1.10.4-alpine AS build

# install build dependencies
RUN apk add --no-cache build-base npm git python

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
FROM alpine:3.9 AS app
RUN apk add --no-cache openssl ncurses-libs
ENV DATABASE_URL=${DATABASE_URL:-postgresql://suum-prod:h5o3ry2dat77qb6d@app-feb12278-0ff1-49bf-9dbc-6edd42f263fd-do-user-2332779-0.b.db.ondigitalocean.com:25060/suum-prod?sslmode=require}

WORKDIR /app

RUN chown nobody:nobody /app

USER nobody:nobody

COPY --from=build --chown=nobody:nobody /app/_build/prod/rel/suum ./
RUN bin/suum eval "Suum.Release.Tasks.create_and_migrate"
ENV HOME=/app
CMD ["bin/suum", "start"]