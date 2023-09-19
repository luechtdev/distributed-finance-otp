FROM elixir:latest

WORKDIR /app
COPY ./apps/exchange_service .
COPY ./config ./config
COPY ./.erlang.cookie ./.erlang.cookie


ENTRYPOINT ["tail", "-f", "/dev/null"]