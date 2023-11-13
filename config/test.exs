import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :prokeep_technical_challenge, ProkeepTechnicalChallengeWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "oyS+/Rx1PVP6SnvFaIifwCnL9M18hVLAdwrA3ISBzIG0zlR4Ktq7HCU26rjrNu/E",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
