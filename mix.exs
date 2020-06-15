defmodule LiveViewCounter.MixProject do
  use Mix.Project

  def project do
    [
      app: :live_view_counter,
      version: "0.10.0",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test, "coveralls.detail": :test,
      "coveralls.json": :test, "coveralls.post": :test, "coveralls.html": :test],
      releases: [
        live_view_counter: [
          include_executables_for: [:unix],
          applications: [
            runtime_tools: :permanent,
            live_view_counter: :permanent
          ]
        ]
      ],
      default_release: :live_view_counter
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {LiveViewCounter.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.5.3"},
      {:phoenix_pubsub, "~> 2.0"},
      {:phoenix_html, "~> 2.14"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:gettext, "~> 0.18"},
      {:jason, "~> 1.2.1"},
      {:plug_cowboy, "~> 2.1"},

      # LiveView
      {:phoenix_live_view, "~> 0.13.1"},
      {:floki, ">= 0.26.0", only: :test},

      # Test Code Coverage:
      {:excoveralls, "~> 0.13.0", only: :test}
    ]
  end
end
