use Mix.Config

config :trihard, Trihard.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [scheme: "https", host: "hidden-reef-19810.herokuapp.com", port: 443],
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  cache_static_manifest: "priv/static/manifest.json",
  secret_key_base: System.get_env("SECRET_KEY_BASE")

config :trihard, Trihard.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: 20

config :logger, level: :info
