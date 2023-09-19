FROM elixir:latest

WORKDIR /app
COPY ./apps/registry .
COPY ./config ./config
COPY ./.erlang.cookie ./.erlang.cookie

ENTRYPOINT ["tail", "-f", "/dev/null"]