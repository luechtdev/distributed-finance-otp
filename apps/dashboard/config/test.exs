import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :dashboard, DashboardWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "HTV0t3VoP6ctypOSjA2C1EVRPWZznNwhStJukRnp2QS+QXuJJEaFk/jjlhf/7XX5",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
