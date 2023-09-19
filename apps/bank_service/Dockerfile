FROM elixir:latest

WORKDIR /app
COPY ./apps/bank_service .
COPY ./config ./config
COPY ./.erlang.cookie ./.erlang.cookie

ENTRYPOINT ["tail", "-f", "/dev/null"]