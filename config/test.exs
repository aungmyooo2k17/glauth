import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :glauth, Glauth.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "glauth_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :glauth, GlauthWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "FBYteE9JHV3Ge1N2XZRPptwl4Dv2TaIaBHOkzqh8pALscJl5WqEt8cEO39FXXYzs",
  server: false

# In test we don't send emails.
config :glauth, Glauth.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
