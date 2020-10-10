FROM elixir:latest
ENV HOME /app
RUN mkdir /app
COPY . /app
WORKDIR /app
RUN mix local.hex --force
RUN mix deps.get
RUN mix local.rebar --force
RUN mix do compile
RUN chmod +x /app/entrypoint.sh
CMD ["/app/entrypoint.sh"]