FROM elixir:1.11
RUN mkdir /app
COPY . /app
WORKDIR /app
RUN mix local.hex --force

RUN mix do compile

CMD ["/app/entrypoint.sh"]