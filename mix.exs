defmodule Lucia.Mixfile do
  use Mix.Project

  def project do
    [app: :lucia,
     version: "1.1.1",
     elixir: "> 1.0.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger, :amqp, :poison, :timex, :httpoison],
     mod: {Lucia, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [{:amqp, "~> 0.1.0"},
     {:poison, "~> 1.5"},
     {:timex, "~> 0.19.0"},
     {:httpoison, "~> 0.7.0"},
     {:exrm, "~> 0.19"}]
  end
end
