use Mix.Config

config :logger, level: :debug

config :lucia, :lights, ids: [2, 3, 4, 5]

config :lucia, :light_api, Lucia.Light.Api.Prod
