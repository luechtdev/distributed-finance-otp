FROM elixir:latest

WORKDIR /app
COPY ./apps/dashboard .
COPY ./.erlang.cookie ./.erlang.cookie

ENTRYPOINT ["tail", "-f", "/dev/null"]